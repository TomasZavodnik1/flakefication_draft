/*
 * Copyright 2020 Morse Micro
 */

#pragma once

#include <stdbool.h>
#include <stdint.h>

#ifdef MORSE_WIN_BUILD
#include <winsock2.h>
#include <windows.h>
#endif

#include "portable_endian.h"
#include "morsectrl.h"

#define PACKED __attribute__((packed))

/*
 * The header for a command
 */
struct PACKED command_hdr
{
    /** Flags - used between host and firmware */
    uint16_t flags;
    /** Message ID - from enum morse_commands_id */
    uint16_t message_id;
    /** Command length excluding the header */
    uint16_t len;
    /** Host sequence id - used between host and firmware only */
    uint16_t host_id;
    /** Interface id - set by the host and copied into the response */
    uint16_t vif_id;
    /** Padding for word alignment */
    uint16_t pad;
};

struct PACKED command
{
    /** The request command starts with a header */
    struct command_hdr hdr;
    /** An opaque data pointer */
    uint8_t data[0];
};

struct PACKED response
{
    /** The confirm header */
    struct command_hdr hdr;
    /** The status of the of the command. @see morse_error_t */
    uint32_t status;
    /** An opaque data pointer */
    uint8_t data[0];
};

/**
 *  Host to firmware/driver messages
 *
 * @note you must hardcode the values here, and they must all be unique
 */
enum morse_commands_id
{
    MORSE_COMMAND_SET_CHANNEL = 0x0001,
    MORSE_COMMAND_GET_VERSION = 0x0002,
    MORSE_COMMAND_SET_TXPOWER = 0x0003,
    MORSE_COMMAND_ADD_INTERFACE = 0x0004,
    MORSE_COMMAND_REMOVE_INTERFACE = 0x0005,
    MORSE_COMMAND_BSS_CONFIG = 0x0006,
    MORSE_COMMAND_APP_STATS_LOG_DEPRECATED = 0x0007,
    MORSE_COMMAND_APP_STATS_LOG = 0x2007,
    MORSE_COMMAND_APP_STATS_RESET = 0x2008,
    MORSE_COMMAND_RPG = 0x0009,
    MORSE_COMMAND_CFG_SCAN = 0x0010,
    MORSE_COMMAND_SET_QOS_PARAMS = 0x0011,
    MORSE_COMMAND_GET_QOS_PARAMS = 0x0012,
    MORSE_COMMAND_GET_FULL_CHANNEL = 0x0013,
    MORSE_COMMAND_SET_STA_STATE = 0x0014,
    MORSE_COMMAND_SET_BSS_COLOR = 0x0015,
    MORSE_COMMAND_TURBO = 0x0018,
    MORSE_COMMAND_HEALTH_CHECK = 0x0019,
    MORSE_COMMAND_SET_CTS_SELF_PS = 0x001A,
    MORSE_COMMAND_SET_DTIM_CHANNEL_CHANGE = 0x001B,
    MORSE_COMMAND_GET_DTIM_CHANNEL = 0x001C,
    MORSE_COMMAND_GET_CURRENT_CHANNEL = 0x001D,
    MORSE_COMMAND_SET_LONG_SLEEP_CONFIG = 0x0021,
    MORSE_COMMAND_SET_DUTY_CYCLE = 0x00022,
    MORSE_COMMAND_GET_DUTY_CYCLE = 0x00023,
    MORSE_COMMAND_GET_CAPABILITIES = 0x00025,
    MORSE_COMMAND_INSTALL_TWT_AGREEMENT = 0x00026,
    MORSE_COMMAND_REMOVE_TWT_AGREEMENT = 0x00027,
    MORSE_COMMAND_GET_TSF = 0x00028,
    MORSE_COMMAND_MAC_ADDR = 0x0029,
    MORSE_COMMAND_MPSW_CONFIG = 0x0030,
    MORSE_COMMAND_STANDBY_MODE = 0x0031,
    MORSE_COMMAND_DHCP_OFFLOAD = 0x0032,
    MORSE_COMMAND_SET_KEEP_ALIVE_OFFLOAD = 0x0033,
    MORSE_COMMAND_GET_SET_GENERIC_PARAM = 0x003E,
    MORSE_COMMAND_UAPSD_CONFIG = 0x0040,

    MORSE_COMMAND_MAC_STATS_LOG_DEPRECATED = 0x000C,
    MORSE_COMMAND_MAC_STATS_LOG = 0x200C,
    MORSE_COMMAND_MAC_STATS_RESET = 0x200D,
    MORSE_COMMAND_UPHY_STATS_LOG_DEPRECATED = 0x000E,
    MORSE_COMMAND_UPHY_STATS_LOG = 0x200E,
    MORSE_COMMAND_UPHY_STATS_RESET = 0x200F,

    /* Temporary Commands that may be removed later */
    MORSE_COMMAND_SET_MODULATION = 0x1000,
    MORSE_COMMAND_GET_RSSI = 0x1002,
    MORSE_COMMAND_SET_IFS = 0x1003,
    MORSE_COMMAND_SET_FEM_SETTINGS = 0x1005,
    MORSE_COMMAND_SET_TXOP = 0x1008,
    MORSE_COMMAND_SET_CONTROL_RESPONSE = 0x1009,
    MORSE_COMMAND_CFG_ACI_SCAN = 0X001F,
    MORSE_COMMAND_SET_PERIODIC_CAL = 0x100A,
    MORSE_COMMAND_SET_BCN_RSSI_THRESHOLD = 0x100B,
    MORSE_COMMAND_SET_TX_PKT_LIFETIME_US = 0x100C,
    MORSE_COMMAND_SET_PHYSM_WATCHDOG = 0x100D,

    /* Commands to driver */
    MORSE_COMMAND_DRIVER_START = 0xA000,
    MORSE_COMMAND_SET_STA_TYPE = 0xA000,
    MORSE_COMMAND_SET_ENC_MODE = 0xA001,
    MORSE_COMMAND_SET_LISTEN_INTERVAL = 0xA003,
    MORSE_COMMAND_SET_AMPDU = 0xA004,
    MORSE_COMMAND_SET_RAW_DEPRECATED = 0xA005,
    MORSE_COMMAND_COREDUMP = 0xA006,
    MORSE_COMMAND_SET_S1G_OP_CLASS = 0xA007,
    MORSE_COMMAND_SEND_WAKE_ACTION_FRAME = 0xA008,
    MORSE_COMMAND_VENDOR_IE_CONFIG = 0xA009,
    MORSE_COMMAND_TWT_SET_CONF = 0xA010,
    MORSE_COMMAND_GET_AVAILABLE_CHANNELS = 0xA011,
    MORSE_COMMAND_SET_ECSA_S1G_INFO = 0xA012,
    MORSE_COMMAND_GET_HW_VERSION = 0xA013,
    MORSE_COMMAND_CAC_SET = 0xA014,
    MORSE_COMMAND_DRIVER_SET_DUTY_CYCLE = 0xA015,
    MORSE_COMMAND_MBSSID_INFO = 0xA016,
    MORSE_COMMAND_OCS_REQ = 0xA017,
    MORSE_COMMAND_MESH_CONFIG = 0xA018,
    MORSE_COMMAND_MBCA_SET_CONF = 0xA019,
    MORSE_COMMAND_DYNAMIC_PEERING_SET_CONF = 0xA020,
    MORSE_COMMAND_CONFIG_RAW = 0xA021,
    MORSE_COMMAND_DRIVER_END,

    /** Test commands start at 0x8000 */
    MORSE_TEST_COMMAND_START_SAMPLEPLAY = 0x8002,
    MORSE_TEST_COMMAND_STOP_SAMPLEPLAY = 0x8003,
    MORSE_TEST_COMMAND_SET_RESPONSE_INDICATION = 0x8007,
    MORSE_TEST_COMMAND_SET_MAC_ACK_TIMEOUT = 0x8008,
    MORSE_TEST_COMMAND_SET_TRANSMISSION_RATE = 0x8009,
    MORSE_TEST_COMMAND_ENERGY_DETECTION_MODE = 0x8023,
    MORSE_TEST_COMMAND_SET_NDP_PROBE_SUPPORT = 0x800C,
    MORSE_TEST_COMMAND_FORCE_ASSERT = 0x800E,
    MORSE_TEST_COMMAND_LNA_BYPASS = 0x800F,
    MORSE_TEST_COMMAND_SET_TX_SCALER = 0x800B,
    MORSE_TEST_COMMAND_TRANSMIT_CW = 0x8020,
    MORSE_TEST_COMMAND_OVERRIDE_PA_ON_DELAY = 0x8021,
    MORSE_TEST_COMMAND_SET_SIG_FIELD_ERROR_EVENT_CONFIG = 0x8011,
    MORSE_TEST_COMMAND_OTP = 0x8014,
    MORSE_COMMAND_SET_ANTENNA = 0x8015,
    MORSE_TEST_COMMAND_SET_MAX_AMPDU_LENGTH = 0x8016,
    MORSE_TEST_COMMAND_TDC_PG_DISABLE = 0x8017,
    MORSE_TEST_COMMAND_DUMP_HW_KEYS = 0x8018,
    MORSE_TEST_COMMAND_PHY_DEAF = 0x8019,
    MORSE_TEST_COMMAND_SET_FSG = 0x8022,
    MORSE_TEST_SET_CAPABILITIES = 0x8118,
    MORSE_TEST_COMMAND_TX_PWR_ADJ = 0x8119,
    MORSE_TEST_COMMAND_SET_AGC_GAIN_CODE = 0x811A,
    MORSE_TEST_COMMAND_GPIO = 0x811B,
};

/**
 * Error numbers the FW may return from commands
 * Defined here as errno numbers are not portable across architectures
 */
enum morse_cmd_return_code {
    MORSE_RET_SUCCESS     = 0,
    MORSE_RET_EPERM       = -1,
    MORSE_RET_ENXIO       = -6,
    MORSE_RET_ENOMEM      = -12,
    MORSE_RET_EINVAL      = -22,
};

int morsectrl_send_command(struct morsectrl_transport *transport,
                           int message_id,
                           struct morsectrl_transport_buff *cmd,
                           struct morsectrl_transport_buff *resp);
