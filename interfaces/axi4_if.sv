interface axi4_if
#(
)
(
    input ACLK, ///< Global clock signal
    input ARESETn ///< Global reset signal, active LOW
);

/**************************************************************************/
// AXI4 Write Address Channel
/**************************************************************************/

logic AWID;     ///< Write address ID
logic AWADDR;   ///< Write address
logic AWLEN;    ///< Burst length
logic AWSIZE;   ///< Burst size
logic AWBURST;  ///< Burst type
logic AWLOCK;   ///< Lock type
logic AWCACHE;  ///< Memory type
logic AWPROT;   ///< Protection type
logic AWQOS;    ///< Quality of Service
logic AWREGION; ///< Region ientifier
logic AWUSER;   ///< User signal
logic AWVALID;  ///< Write address valid
logic AWREADY;  ///< Write address ready

/**************************************************************************/
// AXI4 Write Data Channel
/**************************************************************************/

logic WID;    ///< Write ID tag
logic WDATA;  ///< Write data
logic WSTRB;  ///< Write strobes
logic WLAST;  ///< Write last
logic WUSER;  ///< User signal
logic WVALID; ///< Write valid
logic WREADY; ///< Write ready

/**************************************************************************/
// AXI4 Write Response Channel
/**************************************************************************/

logic BID;    ///< Response ID tag
logic BRESP;  ///< Write response
logic BUSER;  ///< User signal
logic BVALID; ///< Write response valid
logic BREADY; ///< Response ready

/**************************************************************************/
// AXI4 Read Address Channel
/**************************************************************************/

logic ARID;     ///< Read address ID
logic ARADDR;   ///< Read address
logic ARLEN;    ///< Burst length
logic ARSIZE;   ///< Burst size
logic ARBURST;  ///< Burst type
logic ARLOCK;   ///< Lock type
logic ARCACHE;  ///< Memory type
logic ARPROT;   ///< Protection type
logic ARQOS;    ///< Quality of service
logic ARREGION; ///< Region identifier
logic ARUSER;   ///< User signal
logic ARVALID;  ///< Read address valid
logic ARREADY;  ///< Read address ready

/**************************************************************************/
// AXI4 Read Data Channel
/**************************************************************************/

logic RID;    ///< Read ID tag
logic RDATA;  ///< Read data
logic RRESP;  ///< Read response
logic RLAST;  ///< Read last
logic RUSER;  ///< User signal
logic RVALID; ///< Read valid
logic RREADY; ///< Read ready

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
    // Write Resposne Channel
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
    // Write Resposne Channel
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
