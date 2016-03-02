/*
   Copyright 2016 Scott Teal

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

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
