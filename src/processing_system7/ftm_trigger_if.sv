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
