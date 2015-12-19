interface axi3_if
#(
)
(
    input ACLK,   ///< Global clock signal
    input ARESETn ///< Global reset signal, active LOW
);

/**************************************************************************/
// AXI3 Write Address Channel
/**************************************************************************/

logic [3:0]  AWID;     ///< Write address ID
logic [31:0] AWADDR;   ///< Write address
logic [3:0]  AWLEN;    ///< Burst length
logic [2:0]  AWSIZE;   ///< Burst size
logic [1:0]  AWBURST;  ///< Burst type
logic [1:0]  AWLOCK;   ///< Lock type
logic [3:0]  AWCACHE;  ///< Cache type
logic [2:0]  AWPROT;   ///< Protection type
logic        AWVALID;  ///< Write address valid
logic        AWREADY;  ///< Write address ready

/**************************************************************************/
// AXI3 Write Data Channel
/**************************************************************************/

logic [3:0]  WID;    ///< Write ID tag
logic [31:0] WDATA;  ///< Write data
logic [3:0]  WSTRB;  ///< Write strobes
logic        WLAST;  ///< Write last
logic        WVALID; ///< Write valid
logic        WREADY; ///< Write ready

/**************************************************************************/
// AXI3 Write Response Channel
/**************************************************************************/

logic [3:0] BID;    ///< Response ID tag
logic [1:0] BRESP;  ///< Write response
logic       BVALID; ///< Write response valid
logic       BREADY; ///< Response ready

/**************************************************************************/
// AXI3 Read Address Channel
/**************************************************************************/

logic [3:0]  ARID;     ///< Read address ID
logic [31:0] ARADDR;   ///< Read address
logic [3:0]  ARLEN;    ///< Burst length
logic [2:0]  ARSIZE;   ///< Burst size
logic [1:0]  ARBURST;  ///< Burst type
logic [1:0]  ARLOCK;   ///< Lock type
logic [3:0]  ARCACHE;  ///< Memory type
logic [2:0]  ARPROT;   ///< Protection type
logic        ARVALID;  ///< Read address valid
logic        ARREADY;  ///< Read address ready

/**************************************************************************/
// AXI3 Read Data Channel
/**************************************************************************/

logic [3:0]  RID;    ///< Read ID tag
logic [31:0] RDATA;  ///< Read data
logic [1:0]  RRESP;  ///< Read response
logic        RLAST;  ///< Read last
logic        RVALID; ///< Read valid
logic        RREADY; ///< Read ready

/**************************************************************************/
// AXI3 Low-Power Interface
/**************************************************************************/

logic CSYSREQ;    ///< System exit low-power state request
logic CSYSACK;    ///< Exit low-power state acknowledgement
logic CSYSACTIVE; ///< Clock active

// AXI3 Interface Master
modport master (
    // Global Signals
    input  ACLK,
    input  ARESETn,
    // Write Address Channel
    output AWID,
    output AWADDR,
    output AWLEN,
    output AWSIZE,
    output AWBURST,
    output AWLOCK,
    output AWCACHE,
    output AWPROT,
    output AWVALID,
    input  AWREADY,
    // Write Data Channel
    output WID,
    output WDATA,
    output WSTRB,
    output WLAST,
    output WVALID,
    input  WREADY,
    // Write Resposne Channel
    input  BID,
    input  BRESP,
    input  BVALID,
    output BREADY,
    // Read Address Channel
    output ARID,
    output ARADDR,
    output ARLEN,
    output ARSIZE,
    output ARBURST,
    output ARLOCK,
    output ARCACHE,
    output ARPROT,
    output ARVALID,
    input  ARREADY,
    // Read Data Channel
    input  RID,
    input  RDATA,
    input  RRESP,
    input  RLAST,
    input  RVALID,
    output RREADY
);

// AXI3 Interface Slave
modport slave (
    // Global Signals
    input  ACLK,
    input  ARESETn,
    // Write Address Channel
    input  AWID,
    input  AWADDR,
    input  AWLEN,
    input  AWSIZE,
    input  AWBURST,
    input  AWLOCK,
    input  AWCACHE,
    input  AWPROT,
    input  AWVALID,
    output AWREADY,
    // Write Data Channel
    input  WID,
    input  WDATA,
    input  WSTRB,
    input  WLAST,
    input  WVALID,
    output WREADY,
    // Write Resposne Channel
    output BID,
    output BRESP,
    output BVALID,
    input  BREADY,
    // Read Address Channel
    input  ARID,
    input  ARADDR,
    input  ARLEN,
    input  ARSIZE,
    input  ARBURST,
    input  ARLOCK,
    input  ARCACHE,
    input  ARPROT,
    input  ARVALID,
    output ARREADY,
    // Read Data Channel
    output RID,
    output RDATA,
    output RRESP,
    output RLAST,
    output RVALID,
    input  RREADY
);

// AXI3 Interface Low-Power Controller
modport controller (
    output CSYSREQ,
    input  CSYSACK,
    input  CSYSACTIVE
);

// AXI3 Interface Low-Power Peripheral
modport peripheral (
    input  CSYSREQ,
    output CSYSACK,
    output CSYSACTIVE
);

endinterface
