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

module AxilRam #(
    parameter MEM_W = 10
)
(
    AxiLite.S bus
);
timeunit 1ns;
timeprecision 10ps;

/*****************************************************************************/
// Parameter Declarations
/*****************************************************************************/

localparam MEM_SIZE = 1 << MEM_W;

/*****************************************************************************/
// Parameter Validation
/*****************************************************************************/

logic invalidParams;

initial begin
    invalidParams = 1'b0;

    if (bus.ADDR_W < (MEM_W+2)) begin
        $error("AxilRam: AxiLite bus address width is narrower than memory address width. Instance: %m");
        invalidParams = 1'b1;
    end

    if (invalidParams) begin
        $stop;
    end
end

/*****************************************************************************/
// Signal Declarations
/*****************************************************************************/

logic [MEM_W-1:0] wAddr;

logic [31:0] mem [MEM_SIZE-1:0];

/*****************************************************************************/
// Write Transaction
/*****************************************************************************/

initial begin
    bus.awReady = 1'b0;
    bus.wReady = 1'b0;
    bus.bValid = 1'b0;
    wAddr = '0;
    for (int i=0; i<MEM_SIZE; i++) begin
        mem[i] = '0;
    end
end

always_comb begin
    bus.bResp = 2'b00;
end

always @(posedge bus.aclk) begin
    if (!bus.aresetn) begin
        bus.awReady <= 1'b0;
        bus.wReady  <= 1'b0;
        bus.bValid  <= 1'b0;
        wAddr       <= '0;
    end
    else begin
        // Write Side One-hot state machine
        bus.awReady <= bus.awReady ? ~bus.awValid : ((bus.bValid && bus.bReady) || (!bus.awReady && !bus.wReady && !bus.bValid));
        bus.wReady  <= bus.wReady  ? ~bus.wValid  : (bus.awValid && bus.awReady);
        bus.bValid  <= bus.bValid  ? ~bus.bReady  : (bus.wValid  && bus.wReady);

        // Register address
        if (bus.awValid && bus.awReady) begin
            wAddr <= bus.awAddr >> 2;
        end
        // Store data on write
        if (bus.wValid && bus.wReady) begin
            if (bus.wStrb[0]) mem[wAddr][ 7: 0] <= bus.wData[ 7: 0];
            if (bus.wStrb[1]) mem[wAddr][15: 8] <= bus.wData[15: 8];
            if (bus.wStrb[2]) mem[wAddr][23:16] <= bus.wData[23:16];
            if (bus.wStrb[3]) mem[wAddr][31:24] <= bus.wData[31:24];
        end
    end
end

/*****************************************************************************/
// Read Transaction
/*****************************************************************************/

initial begin
    bus.arReady = 1'b0;
    bus.rValid = 1'b0;
    bus.rData = '0;
    bus.rResp = 2'b00;
end

always_comb begin
    bus.rResp = 2'b00;
end

always @(posedge bus.aclk) begin
    if (!bus.aresetn) begin
        bus.arReady <= 1'b0;
        bus.rValid <= 1'b0;
    end
    else begin
        // Read side One-hot state machine
        bus.arReady <= bus.arReady ? ~bus.arValid : ((bus.arValid && bus.arReady) || (!bus.arReady && !bus.rValid));
        bus.rValid  <= bus.rValid  ? ~bus.rReady  : (bus.arValid && bus.arReady);

        // Read data on valid address
        if (bus.arValid && bus.arReady) begin
            bus.rData <= mem[bus.arAddr[MEM_W+1:2]];
        end
    end
end

endmodule
