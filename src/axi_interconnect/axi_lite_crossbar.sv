/**
# AXI4-Lite Crossbar #

An AXI4-Lite crossbar switch. Currently supports only one master. All ACLK 
signals must have the same source.

*/

module axi_lite_crossbar
#(
    parameter NUM_MASTERS = 1,
    parameter NUM_SLAVES = 2,
    parameter [15:0] S_BASE_ID [NUM_SLAVES-1:0] = {16'h4000, 16'h5000}
)    
(
    axi4_lite_if.master m_axi [NUM_MASTERS-1:0],
    axi4_lite_if.slave s_axi [NUM_SLAVES-1:0]
);

genvar i;

// Sanity Check of Parameters
// {{{
initial begin
    if (!(NUM_MASTERS inside {0, 1})) begin
        $display("Attribute Syntax Error : The Attribute NUM_MASTERS on axi_lite_crossbar instance %m is set to %d.  This must be set to 1", NUM_MASTERS);
        $finish();
    end
    if (!(NUM_SLAVES inside {1, 8})) begin
        $display("Attribute Syntax Error : The Attribute NUM_SLAVES on axi_lite_crossbar instance %m is set to %d.  Legal values are 1 to 8.", NUM_SLAVES);
        $finish();
    end
end
// }}}

generate

for (i = 0; i<NUM_SLAVES; i++) begin
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
