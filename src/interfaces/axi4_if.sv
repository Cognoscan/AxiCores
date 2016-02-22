/**
# AXI4 Protocol Bus Interface #

Implements an AXI4 bus interface.
*/
interface axi4_if
#(
    parameter N_BYTES    = 4,   ///< Number of bytes in bus
    parameter ADDR_WIDTH = 12,  ///< Width of address signals
    parameter ID_WIDTH   = 4,   ///< Width of ID signals
    parameter AWUSER_WIDTH = 0, ///< Width of write address user signal
    parameter WUSER_WIDTH  = 0, ///< Width of write data user signal
    parameter BUSER_WIDTH  = 0, ///< Width of write response user signal
    parameter ARUSER_WIDTH = 0, ///< Width of read address user signal
    parameter RUSER_WIDTH  = 0  ///< Width of read data user signal
)
(
    input logic ACLK, ///< Global clock signal
    input logic ARESETn ///< Global reset signal, active LOW
);

// We can't have 0-sized signals, so make them 1 bit and assume nothing attached
// to the bus will use the ID / USER signals.
localparam ID_WIDTH_     = (ID_WIDTH     < 1) ? 1 : ID_WIDTH    ;
localparam AWUSER_WIDTH_ = (AWUSER_WIDTH < 1) ? 1 : AWUSER_WIDTH;
localparam WUSER_WIDTH_  = (WUSER_WIDTH  < 1) ? 1 : WUSER_WIDTH ;
localparam BUSER_WIDTH_  = (BUSER_WIDTH  < 1) ? 1 : BUSER_WIDTH ;
localparam ARUSER_WIDTH_ = (ARUSER_WIDTH < 1) ? 1 : ARUSER_WIDTH;
localparam RUSER_WIDTH_  = (RUSER_WIDTH  < 1) ? 1 : RUSER_WIDTH ;

/**************************************************************************/
// AXI4 Write Address Channel
/**************************************************************************/

logic     [ID_WIDTH_-1:0] AWID;     ///< Write address ID
logic    [ADDR_WIDTH-1:0] AWADDR;   ///< Write address
logic               [7:0] AWLEN;    ///< Burst length
logic               [2:0] AWSIZE;   ///< Burst size
logic               [1:0] AWBURST;  ///< Burst type
logic                     AWLOCK;   ///< Lock type
logic               [3:0] AWCACHE;  ///< Memory type
logic               [2:0] AWPROT;   ///< Protection type
logic               [3:0] AWQOS;    ///< Quality of Service
logic               [3:0] AWREGION; ///< Region ientifier
logic [AWUSER_WIDTH_-1:0] AWUSER;   ///< User signal
logic                     AWVALID;  ///< Write address valid
logic                     AWREADY;  ///< Write address ready

/**************************************************************************/
// AXI4 Write Data Channel
/**************************************************************************/

logic    [ID_WIDTH_-1:0] WID;    ///< Write ID tag
logic    [8*N_BYTES-1:0] WDATA;  ///< Write data
logic      [N_BYTES-1:0] WSTRB;  ///< Write strobes
logic                    WLAST;  ///< Write last
logic [WUSER_WIDTH_-1:0] WUSER;  ///< User signal
logic                    WVALID; ///< Write valid
logic                    WREADY; ///< Write ready

/**************************************************************************/
// AXI4 Write Response Channel
/**************************************************************************/

logic    [ID_WIDTH_-1:0] BID;    ///< Response ID tag
logic              [1:0] BRESP;  ///< Write response
logic [BUSER_WIDTH_-1:0] BUSER;  ///< User signal
logic                    BVALID; ///< Write response valid
logic                    BREADY; ///< Response ready

/**************************************************************************/
// AXI4 Read Address Channel
/**************************************************************************/

logic     [ID_WIDTH_-1:0] ARID;     ///< Read address ID
logic    [ADDR_WIDTH-1:0] ARADDR;   ///< Read address
logic               [7:0] ARLEN;    ///< Burst length
logic               [2:0] ARSIZE;   ///< Burst size
logic               [1:0] ARBURST;  ///< Burst type
logic                     ARLOCK;   ///< Lock type
logic               [3:0] ARCACHE;  ///< Memory type
logic               [2:0] ARPROT;   ///< Protection type
logic               [3:0] ARQOS;    ///< Quality of service
logic               [3:0] ARREGION; ///< Region identifier
logic [ARUSER_WIDTH_-1:0] ARUSER;   ///< User signal
logic                     ARVALID;  ///< Read address valid
logic                     ARREADY;  ///< Read address ready

/**************************************************************************/
// AXI4 Read Data Channel
/**************************************************************************/

logic    [ID_WIDTH_-1:0] RID;    ///< Read ID tag
logic    [8*N_BYTES-1:0] RDATA;  ///< Read data
logic              [1:0] RRESP;  ///< Read response
logic                    RLAST;  ///< Read last
logic [RUSER_WIDTH_-1:0] RUSER;  ///< User signal
logic                    RVALID; ///< Read valid
logic                    RREADY; ///< Read ready

/**************************************************************************/
// AXI4 Low-Power Interface
/**************************************************************************/

logic CSYSREQ;    ///< System exit low-power state request
logic CSYSACK;    ///< Exit low-power state acknowledgement
logic CSYSACTIVE; ///< Clock active

// AXI4 Interface Master
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
    output AWQOS,
    output AWREGION,
    output AWUSER,
    output AWVALID,
    input  AWREADY,
    // Write Data Channel
    output WID,
    output WDATA,
    output WSTRB,
    output WLAST,
    output WUSER,
    output WVALID,
    input  WREADY,
    // Write Response Channel
    input  BID,
    input  BRESP,
    input  BUSER,
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
    output ARQOS,
    output ARREGION,
    output ARUSER,
    output ARVALID,
    input  ARREADY,
    // Read Data Channel
    input  RID,
    input  RDATA,
    input  RRESP,
    input  RLAST,
    input  RUSER,
    input  RVALID,
    output RREADY
);

// AXI4 Interface Slave
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
    input  AWQOS,
    input  AWREGION,
    input  AWUSER,
    input  AWVALID,
    output AWREADY,
    // Write Data Channel
    input  WID,
    input  WDATA,
    input  WSTRB,
    input  WLAST,
    input  WUSER,
    input  WVALID,
    output WREADY,
    // Write Response Channel
    output BID,
    output BRESP,
    output BUSER,
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
    input  ARQOS,
    input  ARREGION,
    input  ARUSER,
    input  ARVALID,
    output ARREADY,
    // Read Data Channel
    output RID,
    output RDATA,
    output RRESP,
    output RLAST,
    output RUSER,
    output RVALID,
    input  RREADY
);

// AXI4 Interface Low-Power Controller
modport controller (
    output CSYSREQ,
    input  CSYSACK,
    input  CSYSACTIVE
);

// AXI4 Interface Low-Power Peripheral
modport peripheral (
    input  CSYSREQ,
    output CSYSACK,
    output CSYSACTIVE
);

endinterface
