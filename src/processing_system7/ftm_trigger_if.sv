/**
# Fabric Trace Module - Trigger Interface #

The signals used by the Zynq Fabric Trace Module for triggering. Allows for 
integrated testing of programmable logic alongside the processor.

- F2P indicates FPGA is triggering Processor
- P2F indicates Processor is triggering FPGA
*/

interface ftm_trigger_if
(
);

logic [3:0]  F2PTRIG;      ///< Asynchronous trigger to CoreSight ECT
logic [3:0]  F2PTRIGACK;   ///< Acknowledge of a trigger to CoreSight ECT
logic [3:0]  P2FTRIG;      ///< Asynchronous trigger from CoreSight ECT
logic [3:0]  P2FTRIGACK;   ///< Acknowledge of a trigger from CoreSight ECT

modport processor (
    input  F2PTRIG,
    output F2PTRIGACK,
    output P2FTRIG,
    input  P2FTRIGACK
);

modport fpga (
    output F2PTRIG,
    input  F2PTRIGACK,
    input  P2FTRIG,
    output P2FTRIGACK
);

endinterface
