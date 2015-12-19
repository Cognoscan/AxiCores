package axi3_types;

    // Burst Size (ARSIZE and AWSIZE)
    typedef enum logic [2:0] {
        BURST_SIZE_1   = 3'b000,
        BURST_SIZE_2   = 3'b001,
        BURST_SIZE_4   = 3'b010,
        BURST_SIZE_8   = 3'b011,
        BURST_SIZE_16  = 3'b100,
        BURST_SIZE_32  = 3'b101,
        BURST_SIZE_64  = 3'b110,
        BURST_SIZE_128 = 3'b111
    } burst_size_t;

    // Burst Types (ARBURST and AWBURST)
    typedef enum logic [1:0] {
        BURST_TYPE_FIXED = 2'b00, // Fixed-address burst (FIFO-type)
        BURST_TYPE_INCR  = 2'b01, // Incrementing-address burst (Normal sequential memory)
        BURST_TYPE_WRAP  = 2'b10  // Incrementing-address that wraps to lower address at boundary (cache line)
    } burst_type_t;

    // Atomic Access (ARLOCK and AWLOCK)
    typedef enum logic [1:0] {
        LOCK_NORMAL    = 2'b00, // Normal access type
        LOCK_EXCLUSIVE = 2'b10, // Exclusive access
        LOCK_LOCKED    = 2'b11  // Locked access
    } lock_t;

    typedef enum logic [1:0] {
        RESP_OKAY   = 2'b00, // Normal access success / exclusive access failure
        RESP_EXOKAY = 2'b01, // Exclusive access success
        RESP_SLVERR = 2'b10, // Access reached slave, but slave wishes to return error
        RESP_DECERR = 2'b11  // Interconnect indicates there is no slave at given address
    } resp_t;

    // Cache Attribute Bits (ARCACHE and AWCACHE)
    // 0 - Bufferable bit
    // 1 - Cacheable bit
    // 2 - Read Allocate bit
    // 3 - Write Allocate bit

    // Protection Unit Support (AWPROT and ARPROT)
    // 0 - Low=normal access, High=priveleged access
    // 1 - Low=secure access, High=non-secure access
    // 2 - Low=data access,   High=instruction access

endpackage
