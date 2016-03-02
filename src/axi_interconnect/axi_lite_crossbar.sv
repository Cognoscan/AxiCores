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
# AXI4-Lite Crossbar #

An AXI4-Lite crossbar switch. Currently supports only one master. All ACLK 
signals must have the same source.

*/

module axi_lite_crossbar
#(
    parameter NUM_MI = 1, ///< Number of master interfaces
    parameter NUM_SI = 2, ///< Number of slave interfaces
    parameter ADDR_WIDTH = 16, ///< Width of address bus
    parameter SI_ADDR_WIDTH = 12, ///< Width of slave address bus
    parameter [ADDR_WIDTH-1:0] S_BASE_ADDR [0:NUM_SI-1] = {16'h4000, 16'h5000} ///< Base address of each slave
)    
(
    axi4_lite_if.master m_axi [NUM_MI-1:0],
    axi4_lite_if.slave s_axi [NUM_SI-1:0]
);

genvar i;

// Sanity Check of Parameters
// {{{
initial begin
    if (!(NUM_MI inside {0, 1})) begin
        $display("Attribute Syntax Error : The Attribute NUM_MI on axi_lite_crossbar instance %m is set to %d.  This must be set to 1", NUM_MI);
        $finish();
    end
    if (!(NUM_SI inside {1, 8})) begin
        $display("Attribute Syntax Error : The Attribute NUM_SI on axi_lite_crossbar instance %m is set to %d.  Legal values are 1 to 8.", NUM_SI);
        $finish();
    end
end
// }}}

generate

for (i = 0; i<NUM_SI; i++) begin
    assign s_axi[i].AWADDR  = '0;
    assign s_axi[i].AWPROT  = '0;
    assign s_axi[i].AWVALID = '0;
    assign s_axi[i].WDATA   = '0;
    assign s_axi[i].WSTRB   = '0;
    assign s_axi[i].WVALID  = '0;
    assign s_axi[i].BREADY  = 1'b1;
    assign s_axi[i].ARADDR  = '0;
    assign s_axi[i].ARPROT  = '0;
    assign s_axi[i].ARVALID = '0;
    assign s_axi[i].RREADY  = 1'b1;
end
endgenerate

assign m_axi[0].AWREADY = 1'b1;
assign m_axi[0].WREADY  = 1'b1;
assign m_axi[0].BRESP   = '0;
assign m_axi[0].BVALID  = '0;
assign m_axi[0].ARREADY = 1'b1;
assign m_axi[0].RDATA   = '0;
assign m_axi[0].RRESP   = '0;
assign m_axi[0].RVALID  = 1'b0;

endmodule
/* vim: set fdm=marker: */
