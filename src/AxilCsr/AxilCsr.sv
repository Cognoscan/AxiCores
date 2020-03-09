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

module AxilCsr #(
    parameter CTRL           = 1, ///< Number of control registers
    parameter STAT           = 1, ///< Number of status registers
    parameter HAS_INTERRUPTS = 0, ///< Whether interrupts are present
    parameter INTERRUPTS     = 1  ///< Number of interrupts (up to 32)
)
(
    AxiLite.S bus,
    output logic [31:0] ctrl [CTRL-1:0],
    input logic [31:0] stat [STAT-1:0],
    input logic [INTERRUPTS-1:0] interrupts,
    output logic irq
);
timeunit 1ns;
timeprecision 10ps;

/*****************************************************************************/
// Parameter Declarations
/*****************************************************************************/

localparam INT_REGS = HAS_INTERRUPTS ? 2 : 0;
localparam ADDR_W = $clog2(CTRL + STAT + INT_REGS);

localparam REG_IRQ_EN = CTRL + STAT;
localparam REG_IRQ_STAT = REG_IRQ_EN + 1;

/*****************************************************************************/
// Parameter Validation
/*****************************************************************************/

logic invalidParams;

initial begin
    invalidParams = 1'b0;

    if (bus.ADDR_W < ADDR_W) begin
        $error("AxilCsr: AxiLite bus address width isn't wide enough to address core, must be at least %0d bits. Instance: %m",
            ADDR_W
        );
        invalidParams = 1'b1;
    end

    if (CTRL < 0) begin
        $error("AxilCsr: Number of control registers cannot be negative. Instance: %m");
        invalidParams = 1'b1;
    end

    if (STAT < 0) begin
        $error("AxilCsr: Number of status registers cannot be negative. Instance: %m");
        invalidParams = 1'b1;
    end

    if (HAS_INTERRUPTS !== 0 && HAS_INTERRUPTS !== 1) begin
        $error("AxilCsr: HAS_INTERRUPTS must be 0 or 1. Instance: %m");
        invalidParams = 1'b1;
    end

    if ((INTERRUPTS < 0) || (INTERRUPTS > 32)) begin
        $error("AxilCsr: INTERRUPTS must be between 0 and 32, but is %0d. Instance: %m", INTERRUPTS);
        invalidParams = 1'b1;
    end

    if (HAS_INTERRUPTS && (INTERRUPTS < 1)) begin
        $error("AxilCsr: INTERRUPTS must be at least 1 if interrupts are enabled. Instance: %m");
        invalidParams = 1'b1;
    end

    if (invalidParams) begin
        $stop;
    end
end

/*****************************************************************************/
// Signal Declarations
/*****************************************************************************/

logic [ADDR_W-1:0] wAddr;
logic [ADDR_W-1:0] rAddr;

logic clk;
logic rstn;

logic [INTERRUPTS-1:0] irqEnable;
logic [INTERRUPTS-1:0] irqStatus;


/*****************************************************************************/
// Clock & Reset
/*****************************************************************************/

assign clk = bus.aclk;
initial rstn = 1'b0;
always @(posedge clk) rstn = bus.aresetn;

/*****************************************************************************/
// Write Transaction
/*****************************************************************************/

initial begin
    bus.awReady = 1'b0;
    bus.wReady = 1'b0;
    bus.bValid = 1'b0;
    wAddr = '0;
    for (int i=0; i<CTRL; i++) begin
        ctrl[i] = '0;
    end
end

always_comb begin
    bus.bResp = 2'b00;
end

always @(posedge clk) begin
    if (!rstn) begin
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
    end
end

genvar g;

// Control registers
generate
for (g=0; g<CTRL; g++) begin
    always @(posedge clk) begin
        if (!rstn) begin
            ctrl[g] <= '0;
        end
        else begin
            if (bus.wValid && bus.wReady && (wAddr == g)) begin
                if (bus.wStrb[0]) ctrl[g][ 7: 0] <= bus.wData[ 7: 0];
                if (bus.wStrb[1]) ctrl[g][15: 8] <= bus.wData[15: 8];
                if (bus.wStrb[2]) ctrl[g][23:16] <= bus.wData[23:16];
                if (bus.wStrb[3]) ctrl[g][31:24] <= bus.wData[31:24];
            end
        end
    end
end
endgenerate

generate
if (HAS_INTERRUPTS) begin

    always @(posedge clk) irq <= |irqStatus;

    for (g=0; g<INTERRUPTS; g++) begin
        always @(posedge clk) begin
            if (!rstn) begin
                irqEnable[g] <= '0;
                irqStatus[g] <= '0;
            end
            else begin
                if (bus.wStrb[g[4:3]] && bus.wValid && bus.wReady && (wAddr == REG_IRQ_EN)) begin
                    irqEnable[g] <= bus.wData[g];
                end

                if (bus.wStrb[g[4:3]] && bus.wValid && bus.wReady && (wAddr == REG_IRQ_STAT)) begin
                    irqStatus[g] <= irqStatus[g]
                        ? ((irqEnable[g] & interrupts[g]) | ~bus.wData[g]) // Stay High if interrupt or TOW not set
                        : ((irqEnable[g] & interrupts[g]) |  bus.wData[g]); // Go high if interrupt or TOW set
                end
                else begin
                    irqStatus[g] <= irqStatus[g] | (interrupts[g] & irqEnable[g]);
                end
            end
        end
    end

end
endgenerate

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
    rAddr = bus.arAddr[ADDR_W+1:2];
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
            if (rAddr < CTRL) begin
                bus.rData <= ctrl[rAddr];
            end
            else if (rAddr < STAT) begin
                bus.rData <= stat[rAddr-CTRL];
            end
            else if (HAS_INTERRUPTS && (rAddr == REG_IRQ_EN)) begin
                bus.rData <= irqEnable;
            end
            else if (HAS_INTERRUPTS && (rAddr == REG_IRQ_STAT)) begin
                bus.rData <= irqStatus;
            end
            else begin
                bus.rData <= '0;
            end
        end
    end
end

endmodule
