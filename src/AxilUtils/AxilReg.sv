/*
   Copyright 2020 Scott Teal

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

module AxilReg #(
    parameter FULL = 0 ///< Set for full clock rate, leave 0 for half clock rate (less logic)
)
(
    AxiLite.S si,
    AxiLite.M mi
);
timeunit 1ns;
timeprecision 10ps;

/*****************************************************************************/
// Parameter Declarations
/*****************************************************************************/

/*****************************************************************************/
// Parameter Validation
/*****************************************************************************/

logic invalidParams;

initial begin
    invalidParams = 1'b0;

    if (si.ADDR_W != mi.ADDR_W) begin
        $error("AxilReg: both AxiLite interfaces must have identical address widths. Instance: %m");
        invalidParams = 1'b1;
    end

    if (invalidParams) begin
        $stop;
    end
end

/*****************************************************************************/
// Signal Declarations
/*****************************************************************************/

logic clk;
logic rstn;

/*****************************************************************************/
// Channel Passthrough
/*****************************************************************************/

assign clk = si.aclk;
assign rstn = si.aresetn;

HandshakeReg #(
    .FULL(FULL),
    .W(si.ADDR_W+3)
)
awChannel (
    .clk(clk),                    ///< System clock
    .rstn(rstn),                  ///< Reset, synchronous and active low
    .inValid(si.awValid),         ///< Set when dIn has valid input data
    .inReady(si.awReady),         ///< High when ready for data
    .dIn({si.awProt, si.awAddr}), ///< [W-1:0] Data into reg
    .outValid(mi.awValid),        ///< High when data available
    .outReady(mi.awReady),        ///< Set when receiver is ready for data
    .dOut({mi.awProt, mi.awAddr}) ///< [W-1:0] Data reg out
);

HandshakeReg #(
    .FULL(FULL),
    .W(36)
)
wChannel (
    .clk(clk),                  ///< System clock
    .rstn(rstn),                ///< Reset, synchronous and active low
    .inValid(si.wValid),        ///< Set when dIn has valid input data
    .inReady(si.wReady),        ///< High when ready for data
    .dIn({si.wStrb, si.wData}), ///< [W-1:0] Data into reg
    .outValid(mi.wValid),       ///< High when data available
    .outReady(mi.wReady),       ///< Set when receiver is ready for data
    .dOut({mi.wStrb, mi.wData}) ///< [W-1:0] Data reg out
);

HandshakeReg #(
    .FULL(FULL),
    .W(2)
)
bChannel (
    .clk(clk),            ///< System clock
    .rstn(rstn),          ///< Reset, synchronous and active low
    .inValid(mi.bValid),  ///< Set when dIn has valid input data
    .inReady(mi.bReady),  ///< High when ready for data
    .dIn(mi.bResp),       ///< [W-1:0] Data into reg
    .outValid(si.bValid), ///< High when data available
    .outReady(si.bReady), ///< Set when receiver is ready for data
    .dOut(si.bResp)       ///< [W-1:0] Data reg out
);

HandshakeReg #(
    .FULL(FULL),
    .W(si.ADDR_W+3)
)
arChannel (
    .clk(clk),                    ///< System clock
    .rstn(rstn),                  ///< Reset, synchronous and active low
    .inValid(si.arValid),         ///< Set when dIn has valid input data
    .inReady(si.arReady),         ///< High when ready for data
    .dIn({si.arProt, si.arAddr}), ///< [W-1:0] Data into reg
    .outValid(mi.arValid),        ///< High when data available
    .outReady(mi.arReady),        ///< Set when receiver is ready for data
    .dOut({mi.arProt, mi.arAddr}) ///< [W-1:0] Data reg out
);

HandshakeReg #(
    .FULL(FULL),
    .W(34)
)
rChannel (
    .clk(clk),                  ///< System clock
    .rstn(rstn),                ///< Reset, synchronous and active low
    .inValid(mi.rValid),        ///< Set when dIn has valid input data
    .inReady(mi.rReady),        ///< High when ready for data
    .dIn({mi.rResp, mi.rData}), ///< [W-1:0] Data into reg
    .outValid(si.rValid),       ///< High when data available
    .outReady(si.rReady),       ///< Set when receiver is ready for data
    .dOut({si.rResp, si.rData}) ///< [W-1:0] Data reg out
);

endmodule
