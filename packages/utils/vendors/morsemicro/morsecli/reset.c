/*
 * Copyright 2020 Morse Micro
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#ifdef MORSE_WIN_BUILD
#include <winsock2.h>
#include <windows.h>
#endif

#include "transport/transport.h"
#include "utilities.h"
#include "command.h"
#ifndef MORSE_WIN_BUILD
#include "gpioctrl.h"
#endif

#define MM610X_CPU_SOFT_RESET_ADDR      (0x10054094)
#define MM610X_CPU_SOFT_RESET_VAL       (0xF)
#define MM610X_CPU_SOFT_UNRESET_VAL     (0xE)
#define MM610X_HOST_INTERRUPT_ADDR      (0x02000000)
#define MM610X_HOST_INTERRUPT_VAL       (0x1)

#define MM610X_REG_MAC_BOOT_ADDR        (0x10054024)
#define MM610X_REG_MAC_BOOT_VALUE       (0x00100000)
#define MM610X_REG_CLK_CTRL_ADDR        (0x1005406C)
#define MM610X_REG_CLK_CTRL_VALUE       (0xEF)
#define MM610X_REG_AON_COUNT            (2)
#define MM610X_REG_AON_ADDR             (0x10058094)
#define MM610X_REG_AON_LATCH_MASK       BIT(0)
#define MM610X_REG_AON_LATCH_ADDR       (0x1005807C)

#define RESET_TIME_MS                   (50)
#define AON_DELAY_MS                    (5)

static struct
{
    struct arg_lit *softreset;
    struct arg_int *gpio;
} args;

int morsectrl_reset(struct morsectrl_transport *transport, int reset_gpio)
{
    int ret = 0;

#ifndef MORSE_WIN_BUILD
    ret = gpio_export(reset_gpio);
    if (ret)
    {
        goto exit;
    }

    ret = gpio_set_dir(reset_gpio, "out");
    if (ret)
    {
        goto exit;
    }

    ret = gpio_set_val(reset_gpio, 0);
    if (ret)
    {
        goto exit;
    }

    sleep_ms(RESET_TIME_MS);
    ret = gpio_set_dir(reset_gpio, "in");
    if (ret)
    {
        goto exit;
    }
    sleep_ms(RESET_TIME_MS);

    /* Reverses the exporting gpio */
    ret = gpio_unexport(reset_gpio);
exit:
#endif

    return ret;
}

/*
 * 'Magic' sequence to reboot chip after performing a reset. Only applies to transports that don't
 *  use the driver.
 */
static int soft_reset(struct morsectrl *mors)
{
    struct morsectrl_transport *transport = &mors->transport;
    int ret;
    int idx;
    uint32_t address = MM610X_REG_AON_ADDR;
    uint32_t latch;

    if (!transport || !transport->tops || !transport->tops->reg_write)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR,
                                "Transport doesn't support soft reset (rebooting)\n");
    }

    /* Clear AON. */
    for (idx = 0; idx < MM610X_REG_AON_COUNT; idx++, address += 4)
    {
        /* clear AON in case there is any latched sleeps */
        ret = morsectrl_transport_reg_write(transport, address, 0);
        if (ret)
        {
            morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to write clk ctrl reg\n");
            return ret;
        }
    }

    /* invoke AON latch procedure */
    ret = morsectrl_transport_reg_read(transport, MM610X_REG_AON_LATCH_ADDR, &latch);
    if (ret)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to read aon latch reg\n");
        return ret;
    }

    ret = morsectrl_transport_reg_write(transport, MM610X_REG_AON_LATCH_ADDR,
                                        latch & ~(MM610X_REG_AON_LATCH_MASK));
    if (ret)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to write aon latch reg\n");
        return ret;
    }
    sleep_ms(AON_DELAY_MS);

    ret = morsectrl_transport_reg_write(transport, MM610X_REG_AON_LATCH_ADDR,
                                        latch | MM610X_REG_AON_LATCH_MASK);
    if (ret)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to write aon latch reg\n");
        return ret;
    }
    sleep_ms(AON_DELAY_MS);

    ret = morsectrl_transport_reg_write(transport, MM610X_REG_AON_LATCH_ADDR,
                                        latch & ~(MM610X_REG_AON_LATCH_MASK));
    if (ret)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to write aon latch reg\n");
        return ret;
    }
    sleep_ms(AON_DELAY_MS);

    /* Boot chip. */
    ret = morsectrl_transport_reg_write(transport, MM610X_REG_MAC_BOOT_ADDR,
                                        MM610X_REG_MAC_BOOT_VALUE);
    if (ret)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to write MAC boot reg\n");
        return ret;
    }

    ret = morsectrl_transport_reg_write(transport, MM610X_REG_CLK_CTRL_ADDR,
                                        MM610X_REG_CLK_CTRL_VALUE);
    if (ret)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to write clk ctrl reg\n");
        return ret;
    }

    ret = morsectrl_transport_reg_write(transport, MM610X_HOST_INTERRUPT_ADDR,
                                        MM610X_HOST_INTERRUPT_VAL);
    if (ret)
    {
        morsectrl_transport_err("Soft Reset", -ETRANSERR, "Failed to write host interrupt reg\n");
        return ret;
    }

    return ret;
}

int reset_init(struct morsectrl *mors, struct mm_argtable *mm_args)
{
    args.softreset = arg_lit0("s", "softreset", "do a soft reset"),
    args.gpio = arg_int0(NULL, NULL, "gpio", "RPi GPIO number");

    switch (mors->transport.type)
    {
#ifdef ENABLE_TRANS_FTDI_SPI
    case MORSECTRL_TRANSPORT_FTDI_SPI:
        MM_INIT_ARGTABLE(mm_args, args.softreset);
        break;
#endif
    default:
        MM_INIT_ARGTABLE(mm_args, args.softreset, args.gpio);
    }

    return 0;
}

int reset(struct morsectrl *mors, int argc, char *argv[])
{
    int ret;
    int reset_gpio = 0;
    bool do_soft_reset = (args.softreset->count > 0);

    if (do_soft_reset)
    {
        ret = soft_reset(mors);
    }
    else
    {
        if (args.gpio->count == 0)
        {
            if (mors->transport.has_reset)
            {
                ret = morsectrl_transport_reset_device(&mors->transport);
                goto exit;
            }
            else
            {
#ifndef MORSE_WIN_BUILD
                reset_gpio = gpio_get_env(RESET_GPIO);

                if (reset_gpio == -1)
                {
                    mctrl_err("Couldn't identify GPIO\n"
                              "Try entering GPIO manually or export %s to your env var\n",
                              RESET_GPIO);

                    return -1;
                }
#endif
            }
        }
        else
        {
            reset_gpio = args.gpio->ival[0];
        }

        ret = morsectrl_reset(&mors->transport, reset_gpio);
    }


exit:
    if (ret < 0)
    {
        mctrl_err("Failed to reset chip\n");
    }

    return ret;
}

MM_CLI_HANDLER(reset, MM_INTF_NOT_REQUIRED, MM_DIRECT_CHIP_SUPPORTED);
