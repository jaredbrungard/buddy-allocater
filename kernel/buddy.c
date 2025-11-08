#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

// The buddy allocator.

// A header for all blocks (16 bytes)
struct header
{
    uint64 magic;
    uint64 size;
};

// When a block is free, its "usable" space starts with a pointer
// to the next free block of that size.
struct free_block
{
    struct free_block *next;
};

// Magic numbers
#define MAGIC_USED 0xdeadbeefbeefdead // Magic for a used block
#define MAGIC_FREE 0xfeedbeeffeebdeef // Magic for a free block

// Block size orders (2^order)
#define MIN_ORDER 5  // Smallest block: 2^5 = 32 bytes
#define MAX_ORDER 12 // Largest block: 2^12 = 4096 bytes
#define MAX_SIZE (1L << MAX_ORDER)

// We need 7 free lists for sizes 32, 64, 128, 256, 512, 1024, 2048.
// These correspond to orders 5 through 11.
#define NUM_LISTS (MAX_ORDER - MIN_ORDER) // 7 lists

// Array of free list heads
struct free_block *free_lists[NUM_LISTS];

// Spinlock for thread safety
struct spinlock buddy_lock;

// --- Helper Functions ---

// Get list index from a size order (e.g., order 5 -> index 0)
static int
order_to_index(int order)
{
    return order - MIN_ORDER;
}

// Get size order (log2) from a size (e.g., 32 -> 5)
// Returns -1 if size is not a power of two.
static int
size_to_order(uint64 size)
{
    int order = 0;
    uint64 s = size;
    while (s > 1)
    {
        s >>= 1;
        order++;
    }
    // Verify it was a power of two
    if (1L << order != size)
    {
        return -1;
    }
    return order;
}

// Get block header from a "usable" pointer
static struct header *
ptr_to_block(void *ptr)
{
    return (struct header *)((char *)ptr - sizeof(struct header));
}

// Get "usable" pointer from a block header
static void *
block_to_ptr(struct header *block)
{
    return (void *)((char *)block + sizeof(struct header));
}

// --- End Helper Functions ---

// Initialize the buddy allocator
void buddyinit(void)
{
    initlock(&buddy_lock, "buddy");
    for (int i = 0; i < NUM_LISTS; i++)
    {
        free_lists[i] = 0;
    }
}

// Insert a block into the correct free list, ordered by address.
static void
insert_free_block(struct header *block)
{
    block->magic = MAGIC_FREE;
    int order = size_to_order(block->size);
    int index = order_to_index(order);

    struct free_block *fb_to_add = (struct free_block *)block_to_ptr(block);

    struct free_block **list_head = &free_lists[index];
    struct free_block *rover = *list_head;
    struct free_block *prev = 0;

    // Find insertion point to keep list sorted by address
    while (rover && (uint64)rover < (uint64)fb_to_add)
    {
        prev = rover;
        rover = rover->next;
    }

    if (prev)
    {
        prev->next = fb_to_add;
    }
    else
    {
        *list_head = fb_to_add;
    }
    fb_to_add->next = rover;
}

// Allocate a block of at least `length` bytes
void *
buddy_alloc(uint64 length)
{
    if (length == 0 || length > (MAX_SIZE - sizeof(struct header)))
    {
        return 0; // Request is 0 or larger than 4080 bytes
    }

    // Calculate smallest power-of-two size that fits the request + header
    uint64 total_needed = length + sizeof(struct header);
    uint64 size = 1L << MIN_ORDER; // Start at 32
    while (size < total_needed)
    {
        size <<= 1;
    }
    // `size` is now 32, 64, ..., 2048, or 4096.

    acquire(&buddy_lock);

    // Special case: request needs a full 4096-byte block
    if (size == MAX_SIZE)
    {
        struct header *block = (struct header *)kalloc();
        if (!block)
        {
            release(&buddy_lock);
            return 0; // kalloc failed
        }
        block->magic = MAGIC_USED;
        block->size = MAX_SIZE;
        release(&buddy_lock);
        return block_to_ptr(block);
    }

    // General case: request needs <= 2048 bytes
    int target_order = size_to_order(size);
    int target_index = order_to_index(target_order);

    // Find the smallest available block that is large enough
    int i;
    for (i = target_index; i < NUM_LISTS; i++)
    {
        if (free_lists[i])
        {
            break; // Found a list with blocks
        }
    }

    struct header *block_to_use;
    int found_order;

    if (i == NUM_LISTS)
    {
        // No free blocks of any suitable size. Allocate a new 4096-byte page.
        block_to_use = (struct header *)kalloc();
        if (!block_to_use)
        {
            release(&buddy_lock);
            return 0;
        }
        block_to_use->size = MAX_SIZE;
        found_order = MAX_ORDER;
    }
    else
    {
        // Found a block on list `i`. Pop it.
        struct free_block *fb = free_lists[i];
        free_lists[i] = fb->next; // Unlink from list

        block_to_use = ptr_to_block(fb);
        found_order = size_to_order(block_to_use->size);
    }

    // Split the block `block_to_use` (of order `found_order`)
    // down to `target_order`.
    while (found_order > target_order)
    {
        uint64 current_size = 1L << found_order;
        uint64 split_size = current_size / 2;

        // `block_to_use` becomes the first half
        block_to_use->size = split_size;

        // The buddy is the second half
        struct header *buddy = (struct header *)((char *)block_to_use + split_size);
        buddy->size = split_size;

        // Add buddy to its free list
        insert_free_block(buddy);

        found_order--; // Continue splitting the first half
    }

    // Mark the final block as used
    block_to_use->magic = MAGIC_USED;
    release(&buddy_lock);

    return block_to_ptr(block_to_use);
}

// Free a previously allocated block
void buddy_free(void *ptr)
{
    if (ptr == 0)
    {
        return; // Do nothing if freeing a null pointer
    }

    struct header *block = ptr_to_block(ptr);

    // --- Validate the block ---
    if (block->magic != MAGIC_USED)
    {
        panic("buddy_free: invalid magic number");
    }

    uint64 size = block->size;
    int order = size_to_order(size);

    if (order < MIN_ORDER || order > MAX_ORDER)
    {
        panic("buddy_free: invalid block size");
    }

    // Check alignment
    if ((uint64)block % size != 0)
    {
        panic("buddy_free: invalid alignment");
    }

    acquire(&buddy_lock);

    // --- Coalescing Loop ---
    // Start with the block to free and try to merge up.

    while (order < MAX_ORDER - 1)
    { // Stop if we reach 2048
        uint64 buddy_addr = (uint64)block ^ size;
        struct header *buddy = (struct header *)buddy_addr;

        // Check if buddy is also free and has the same size
        if (buddy->magic != MAGIC_FREE || buddy->size != size)
        {
            break; // Buddy is not free or wrong size, stop merging
        }

        // --- Buddy is free and correct size, so merge ---

        // 1. Remove buddy from its free list
        int current_index = order_to_index(order);
        struct free_block **list_head = &free_lists[current_index];
        struct free_block *rover = *list_head;
        struct free_block *prev = 0;

        struct free_block *fb_buddy = (struct free_block *)block_to_ptr(buddy);

        while (rover && rover != fb_buddy)
        {
            prev = rover;
            rover = rover->next;
        }

        if (rover == 0)
        {
            // Should not happen if magic was FREE
            panic("buddy_free: free list corruption");
        }

        // Unlink buddy
        if (prev)
        {
            prev->next = rover->next;
        }
        else
        {
            *list_head = rover->next;
        }

        // 2. Create new, larger merged block
        if ((uint64)buddy < (uint64)block)
        {
            block = buddy; // New block starts at buddy's address
        }

        order++;
        size = 1L << order;
        block->size = size;

        // Loop again to try merging this new larger block
    }

    // --- End Coalescing Loop ---

    if (order == MAX_ORDER)
    {
        // We merged up to a 4096-byte block. Return it to kfree.
        block->magic = 0; // Invalidate magic
        kfree((void *)block);
    }
    else
    {
        // Add the (potentially merged) block to the appropriate free list
        insert_free_block(block);
    }

    release(&buddy_lock);
}

// Recursive helper for buddy_print
// Recursive helper for buddy_print
// Recursive helper for buddy_print
// Recursive helper for buddy_print
static void
print_tree(struct header *block, int order, char *prefix, int is_top)
{
    uint64 size = 1L << order;

    // Print the prefix string passed down from the parent
    printf("%s", prefix);

    // Check if this block is a "leaf" (not split further)
    if (block->size == size)
    {
        // This block is not split (it's a leaf at this level)
        printf("%s", is_top ? "┌──── " : "└─────── ");

        if (block->magic == MAGIC_USED)
            printf("used (%lu)\n", size);
        else if (block->magic == MAGIC_FREE)
            printf("free (%lu)\n", size);
        else
            printf("corrupt (%lu)\n", size);
    }
    else
    {
        // This block is split
        uint64 split_size = size / 2;
        int next_order = order - 1;
        struct header *buddy = (struct header *)((char *)block + split_size);
        uint64 len = strlen(prefix);

        // --- FIX IS HERE ---
        // Use a *single* 256-byte buffer for the next prefix
        char next_prefix[256];

        // 1. Prepare and recurse for *top* child
        if (len + 11 > 256) { // 10 bytes for "│       " + 1 null
            printf("buddy_print: prefix string too long\n");
            return;
        }
        memmove(next_prefix, prefix, len);
        memmove(next_prefix + len, "│       ", 10); // 10 bytes
        next_prefix[len + 10] = '\0';

        print_tree(buddy, next_order, next_prefix, 1); // 1 = is top child

        // 2. Print our own junction
        printf("%s%s", prefix, is_top ? "├───┤\n" : "└───────┤\n");

        // 3. Prepare and recurse for *bottom* child
        // We re-use the *same* 'next_prefix' buffer
        if (len + 9 > 256) { // 8 bytes for "        " + 1 null
             printf("buddy_print: prefix string too long\n");
             return;
        }
        memmove(next_prefix, prefix, len);
        memmove(next_prefix + len, "        ", 8); // 8 bytes
        next_prefix[len + 8] = '\0';

        print_tree(block, next_order, next_prefix, 0); // 0 = is bottom child
    }
}
// Print the structure of a 4096-byte block
void buddy_print(void *ptr)
{
    if (ptr == 0)
    {
        printf("\nbuddy_print: null pointer\n");
        return;
    }

    struct header *block = ptr_to_block(ptr);
    uint64 page_addr = (uint64)block & ~(MAX_SIZE - 1);
    struct header *page = (struct header *)page_addr;

    printf("\n"); // Start with a newline per example

    // Check the 4096-byte page itself
    if (page->size == MAX_SIZE)
    {
        if (page->magic == MAGIC_USED)
        {
            printf("used (4096)\n");
        }
        else if (page->magic == MAGIC_FREE)
        {
            printf("free (4096)\n");
        }
        else
        {
            printf("corrupt (4096)\n");
        }
    }
    else
    {
        // It's split. Call the recursive helper.
        uint64 split_size = MAX_SIZE / 2;
        struct header *buddy = (struct header *)((char *)page + split_size);

        // We pass "   " (3 ASCII spaces) as the *base* prefix
        print_tree(buddy, MAX_ORDER - 1, "   ", 1); // 1 = is top child
        printf("───┤\n");
        print_tree(page, MAX_ORDER - 1, "   ", 0); // 0 = is bottom child
    }
}
// Test function as provided in the prompt
void buddy_test(void)
{
    printf("Starting buddy test\n");

    printf("\nallocating 1024-byte block\n");
    void *e = buddy_alloc(1000);
    buddy_print(e);

    printf("\nallocating 128-byte block\n");
    void *c = buddy_alloc(112);
    buddy_print(c);

    printf("\nallocating 32-byte block\n");
    void *a = buddy_alloc(16);
    buddy_print(a);

    printf("\nfreeing 1024-byte block\n");
    buddy_free(e);
    buddy_print(a);

    printf("\nallocating 128-byte block\n");
    void *b = buddy_alloc(112);
    buddy_print(b);

    printf("\nfreeing 32-byte block\n");
    buddy_free(a);
    buddy_print(b);

    printf("\nfreeing first 128-byte block\n");
    buddy_free(c);
    buddy_print(b);

    printf("\nallocating 2048-byte block\n");
    void *d = buddy_alloc(2000);
    buddy_print(d);

    printf("\nfreeing other 128-byte block\n");
    buddy_free(b);
    buddy_print(d);

    printf("\nfreeing 2048-byte block\n");
    buddy_free(d);
}
