/**
# Fabric Trace Module - Trace Interface #

The signals used by the Zynq Fabric Trace Module for actual tracing. Allows for 
integrated testing of programmable logic alongside the processor.
*/

interface ftm_trace_if
(
);

logic [31:0] DATA;  ///< Trace data (requires all 32 bits)
logic [3:0]  ATID;  ///< Trace ID to go over ATB
logic        VALID; ///< When high, DATA and ATID are valid
logic        CLOCK; ///< Clock signal. Asynchronous to processor

modport processor (
    input  DATA,
    input  ATID,
    input  VALID,
    input  CLOCK
);

modport fpga (
    output DATA,
    output ATID,
    output VALID,
    output CLOCK
);

endinterface
