/**
# AXI3 Protocol Bus Interface #

Implements an AXI3 bus interface. For Xilinx compatibility reasons, this also 
includes the AWQOS and ARQOS signals from AXI4. It is up to the system designer 
to use them appropriately. For true AXI3 masters, both QOS signals should be set 
to 4'b0000.

In another departure from the standard, this version only allows for 2-bit 
AWBURST and ARBURST signals, instead of the 3-bit signals specified. This is 
also done to ensure compatibility with Xilinx IP, as well as certain ARM 
MPCores.
*/
interface axi3_if
#(
    parameter N_BYTES    = 4,  ///< Number of bytes in bus
    parameter ADDR_WIDTH = 12, ///< Width of address signals
    parameter ID_WIDTH   = 4   ///< Width of ID signals
)
(
    input logic ACLK,   ///< Global clock signal
    input logic ARESETn ///< Global reset signal, active LOW
);

// We can't have 0-sized signals, so make them 1 bit and assume nothing attached
// to the bus will use the ID bit signals.
localparam ID_WIDTH_ = (ID_WIDTH < 1) ? 1 : ID_WIDTH;

/**************************************************************************/
// AXI3 Write Address Channel
/**************************************************************************/

logic  [ID_WIDTH_-1:0] AWID;    ///< Write address ID
logic [ADDR_WIDTH-1:0] AWADDR;  ///< Write address
logic            [3:0] AWLEN;   ///< Burst length
logic            [1:0] AWSIZE;  ///< Burst size
logic            [1:0] AWBURST; ///< Burst type
logic            [1:0] AWLOCK;  ///< Lock type
logic            [3:0] AWCACHE; ///< Cache type
logic            [2:0] AWPROT;  ///< Protection type
logic            [3:0] AWQOS;   ///< Quality of service
logic                  AWVALID; ///< Write address valid
logic                  AWREADY; ///< Write address ready

/**************************************************************************/
// AXI3 Write Data Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] WID;    ///< Write ID tag
logic [8*N_BYTES-1:0] WDATA;  ///< Write data
logic   [N_BYTES-1:0] WSTRB;  ///< Write strobes
logic                 WLAST;  ///< Write last
logic                 WVALID; ///< Write valid
logic                 WREADY; ///< Write ready

/**************************************************************************/
// AXI3 Write Response Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] BID;    ///< Response ID tag
logic           [1:0] BRESP;  ///< Write response
logic                 BVALID; ///< Write response valid
logic                 BREADY; ///< Response ready

/**************************************************************************/
// AXI3 Read Address Channel
/**************************************************************************/

logic  [ID_WIDTH_-1:0] ARID;    ///< Read address ID
logic [ADDR_WIDTH-1:0] ARADDR;  ///< Read address
logic            [3:0] ARLEN;   ///< Burst length
logic            [1:0] ARSIZE;  ///< Burst size
logic            [1:0] ARBURST; ///< Burst type
logic            [1:0] ARLOCK;  ///< Lock type
logic            [3:0] ARCACHE; ///< Memory type
logic            [2:0] ARPROT;  ///< Protection type
logic            [3:0] ARQOS;   ///< Quality of service
logic                  ARVALID; ///< Read address valid
logic                  ARREADY; ///< Read address ready

/**************************************************************************/
// AXI3 Read Data Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] RID;    ///< Read ID tag
logic [8*N_BYTES-1:0] RDATA;  ///< Read data
logic           [1:0] RRESP;  ///< Read response
logic                 RLAST;  ///< Read last
logic                 RVALID; ///< Read valid
logic                 RREADY; ///< Read ready

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
    output AWQOS,
    output AWVALID,
    input  AWREADY,
    // Write Data Channel
    output WID,
    output WDATA,
    output WSTRB,
    output WLAST,
    output WVALID,
    input  WREADY,
    // Write Response Channel
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
    output ARQOS,
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
    input  AWQOS,
    input  AWVALID,
    output AWREADY,
    // Write Data Channel
    input  WID,
    input  WDATA,
    input  WSTRB,
    input  WLAST,
    input  WVALID,
    output WREADY,
    // Write Response Channel
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
    input  ARQOS,
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
