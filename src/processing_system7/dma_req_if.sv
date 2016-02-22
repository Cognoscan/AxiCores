/**
# dma_req_if - DMA Request Interface #

Provides an interface to a Zynq DMA request channel. The DMA Controller (DMAC) 
uses these channels to allow a peripheral to request a transfer.
*/

interface dma_req_if
(
    input logic ACLK
);

typedef enum logic [1:0] {
    SINGLE_REQ = 2'b00, // Single level request
    BURST_REQ  = 2'b01, // Burst level request
    FLUSH_ACK  = 2'b10  // Acknowledging a flush request from DMAC
} drtype_t;

typedef enum logic [1:0] {
    SINGLE_DONE = 2'b00, // DMAC has completed single AXI transaction
    BURST_DONE  = 2'b01, // DMAC has completed burst AXI transaction
    FLUSH_REQ   = 2'b10  // DMAC requesting a flush
} datype_t;

logic       RSTN;    ///< Active low reset from DMA.
logic       DRVALID; ///< Valid control information from peripheral
logic       DRLAST;  ///< Sending last AXI transaction for current transfer
logic [1:0] DRTYPE;  ///< ACK / Request type from peripheral
logic       DRREADY; ///< DMAC is ready to accept info on DRTYPE
logic       DAVALID; ///< Valid control information from DMAC
logic       DAREADY; ///< Peripheral is ready to accept info on DATYPE
logic [1:0] DATYPE;  ///< ACK / Request type from peripheral

modport zynq (
    input  ACLK,
    output RSTN,
    input  DRVALID,
    input  DRLAST,
    input  DRTYPE,
    output DRREADY,
    output DAVALID,
    input  DAREADY,
    output DATYPE
);

modport peripheral (
    input  ACLK,
    input  RSTN,
    output DRVALID,
    output DRLAST,
    output DRTYPE,
    input  DRREADY,
    input  DAVALID,
    output DAREADY,
    input  DATYPE
);

endinterface
