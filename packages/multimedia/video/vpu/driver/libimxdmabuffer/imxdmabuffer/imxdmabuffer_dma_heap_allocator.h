#ifndef IMXDMABUFFER_DMA_HEAP_ALLOCATOR_H
#define IMXDMABUFFER_DMA_HEAP_ALLOCATOR_H

#include "imxdmabuffer.h"


#ifdef __cplusplus
extern "C" {
#endif


extern unsigned int const IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_HEAP_FLAGS;
extern unsigned int const IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_FD_FLAGS;


/* Creates a new DMA buffer allocator that uses a modified dma-heap allocator.
 *
 * The i.MX kernel contains a modified version of the dma-heap allocator which
 * was introduced in Linux 5.6 and is intended to replace ION. The modified
 * i.MX kernel variant has an extra ioctl for fetching a physical address for
 * a DMA-BUF FD. This allocator produces ImxDmaBuffer instances that are
 * DMA-BUF backed. imx_dma_buffer_get_fd() returns the DMA-BUF FD.
 *
 * If dma_heap_fd is <0, an internal dma-heap FD (not to be confused with
 * DMA-BUF FDs) is used. The device node path to use is configured at the time
 * when libimxdmabuffer is built. Typically, the default device node path
 * is set to "/dev/dma_heap/linux,cma". Whether that dma-heap allocates
 * cached or uncached memory is also defined at build time.
 *
 * NOTE: Using this with dma_heap_fd set to a valid FD is deprecated, because
 * this function does not allow for specifying whether this dma-heap allocates
 * cached memory. Instead, use imx_dma_buffer_dma_heap_allocator_new_from_fd()
 * to reuse an already openeded dma-heap device node.
 *
 * @param dma_heap_fd File descriptor of an open instance of the dma-heap
 *        device node, or <0 to let the allocator open an internal FD.
 * @param heap_flags dma-heap flags. To use default flags, set this to
 *        IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_HEAP_FLAGS.
 * @param fd_flags Flags for the DMA-BUF FD of newly allocated buffers.
 *        Set this to IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_FD_FLAGS
 *        to use default flags.
 * @param error If this pointer is non-NULL, and if an error occurs, then the
 *        integer the pointer refers to is set to an error code from errno.h.
 *        If creating the allocator succeeds, the integer is not modified.
 */
ImxDmaBufferAllocator* imx_dma_buffer_dma_heap_allocator_new(
	int dma_heap_fd,
	unsigned int heap_flags,
	unsigned int fd_flags,
	int *error
);

/* Creates a new DMA buffer allocator that uses an already opened dma-heap FD.
 *
 * This is similar to imx_dma_buffer_dma_heap_allocator_new(), except that it
 * does not open its own dma-heap FD. Instead, it reuses an existing one.
 *
 * This also allows for specifying whether that dma-heap allocates cached
 * memory or not, which is important for performance reasons: If the dma-heap
 * allocates uncached memory, then the imx_dma_buffer_start_sync_session()
 * and imx_dma_buffer_stop_sync_session() functions do nothing.
 *
 * @param dma_heap_fd File descriptor of an open instance of the dma-heap
 *        device node. Must be a valid FD.
 * @param heap_flags dma-heap flags. To use default flags, set this to
 *        IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_HEAP_FLAGS.
 * @param fd_flags Flags for the DMA-BUF FD of newly allocated buffers.
 *        Set this to IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_FD_FLAGS
 *        to use default flags.
 * @param is_cached_memory_heap If nonzero, then this dma-heap is considered
 *        as being one that allocates cached memory. If zero, it is considered
 *        an uncached DMA memory allocator.
 */
ImxDmaBufferAllocator* imx_dma_buffer_dma_heap_allocator_new_from_fd(
    int dma_heap_fd,
    unsigned int heap_flags,
    unsigned int fd_flags,
    int is_cached_memory_heap
);

/* Returns the file descriptor of the opened dma-heap device node this allocator uses. */
int imx_dma_buffer_dma_heap_allocator_get_dma_heap_fd(ImxDmaBufferAllocator *allocator);


/* Allocates a DMA buffer with dma-heap and returns the file descriptor representing the buffer.
 *
 * This function is useful for assembling a custom allocator that uses dma-heap.
 * This may be necessary in frameworks that have their own memory allocation
 * infrastructure and already have code in place for mapping/unmapping file
 * descriptors for example. Usually it is better to just use the predefined
 * dma-heap imxdmabuffer allocator instead. To create an instance of that
 * allocator, use imx_dma_buffer_dma_heap_allocator_new().
 *
 * @param dma_heap_fd dma-heap file descriptor to use. Must not be negative.
 * @param size Size of the DMA buffer to allocate, in bytes.
 *        Must be greater than 0.
 * @param heap_flags dma-heap flags. To use default flags, set this to
 *        IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_HEAP_FLAGS.
 * @param fd_flags Flags for the DMA-BUF FD of newly allocated buffers.
 *        Set this to IMX_DMA_BUFFER_DMA_HEAP_ALLOCATOR_DEFAULT_FD_FLAGS
 *        to use default flags.
 * @param error If this pointer is non-NULL, and if an error occurs, then the
 *        integer the pointer refers to is set to an error code from errno.h.
 *        If allocation succeeds, the integer is not modified.
 * @return DMA-BUF FD for the allocated DMA buffer, or a negative value
 *         if allocation failed.
 */
int imx_dma_buffer_dma_heap_allocate_dmabuf(
	int dma_heap_fd,
	size_t size,
	unsigned int heap_flags,
	unsigned int fd_flags,
	int *error
);

/* Retrieves a physical address for the DMA buffer with the given DMA-BUF FD.
 *
 * @param dmabuf_fd DMA-BUF file descriptor to retrieve a physical address for.
 * @param error If this pointer is non-NULL, and if an error occurs, then the
 *        integer the pointer refers to is set to an error code from errno.h. If
 *        retrieving the physical address succeeds, the integer is not modified.
 * @return Physical address to the DMA buffer represented by the DMA-BUF FD, or
 *         0 if retrieving the address failed.
 */
imx_physical_address_t imx_dma_buffer_dma_heap_get_physical_address_from_dmabuf_fd(int dmabuf_fd, int *error);


#ifdef __cplusplus
}
#endif


#endif /* IMXDMABUFFER_DMA_HEAP_ALLOCATOR_H */
