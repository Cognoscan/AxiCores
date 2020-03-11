module AxilCsr_tb #(
    parameter CTRL           = 5, ///< Number of control registers
    parameter STAT           = 4, ///< Number of status registers
    parameter HAS_INTERRUPTS = 1, ///< Whether interrupts are present
    parameter INTERRUPTS     = 32  ///< Number of interrupts (up to 32)
)
(
    input  logic start,
    output logic done,
    output logic pass
);
timeunit 1ns;
timeprecision 10ps;

/*****************************************************************************/
// Parameter Declarations
/*****************************************************************************/

localparam ADDR_CNT = CTRL + STAT + 2; // Minimum # of addresses
localparam ADDR_W = $clog2(ADDR_CNT) + 2; // ADDR+2 for byte addresses

/*****************************************************************************/
// Signal Declarations
/*****************************************************************************/

logic clk;
logic rstn;

bit busSuccess;
bit busPass;

logic [31:0] writeData;
logic [31:0] readData;
logic [ADDR_W-1:0] addr;
logic [31:0] testReg;
logic [3:0] testStrb;

AxiLite #(ADDR_W) bus (clk, rstn);
logic [31:0] ctrl [CTRL-1:0];
logic [31:0] stat [STAT-1:0];
logic [INTERRUPTS-1:0] interrupts;
logic irq;

/*****************************************************************************/
// Test Code
/*****************************************************************************/

task TestCtrl (
    input int i,
    input int data,
    input int expected,
    input logic [3:0] strb
);
begin
    bus.Write(i<<2, data, strb, busSuccess); busPass &= busSuccess;
    #10
    bus.Read(i<<2, readData, busSuccess); busPass &= busSuccess;
    if (readData !== expected) begin
        $display("%m: Expected 0x%0x @ address 0x%0x, got 0x%0x", expected, i<<2, readData);
        pass = 1'b0;
    end
    if (ctrl[i] !== expected) begin
        $display("%m: Expected 0x%0x @ ctrl %0d, got 0x%0x", expected, i, ctrl[i]);
        pass = 1'b0;
    end
end
endtask

task TestStat (
    input int i,
    input int data
);
begin
    stat[i] = data;
    bus.Read((i+CTRL)<<2, readData, busSuccess); busPass &= busSuccess;
    if (readData !== 0) begin
        $display("%m: Expected 0x%0x @ address 0x%0x, got 0x%0x", 0, i<<2, readData);
        pass = 1'b0;
    end
end
endtask

always #1 if ((start !== 1'b0) && !done) clk = ~clk;

initial begin
    clk = 1'b0;
    rstn = 1'b0;
    done = 1'b0;
    pass = 1'b1;
    busPass = 1'b1;
    bus.MasterInit;
    for (int i=0; i<STAT; i++) begin
        stat[i] = '0;
    end
    interrupts = '0;
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b1;

    // Test all CTRL registers
    $display("%m: Testing CTRL registers");
    for (int i=0; i<CTRL; i++) begin
        TestCtrl(i, 0, 0, 0);
        TestCtrl(i, 32'h5555_5555, 32'h0000_0055, 4'h1);
        TestCtrl(i, 32'h5555_5555, 32'h0000_5555, 4'h2);
        TestCtrl(i, 32'h5555_5555, 32'h0055_5555, 4'h4);
        TestCtrl(i, 32'h5555_5555, 32'h5555_5555, 4'h8);
        TestCtrl(i, 32'hAAAA_AAAA, 32'hAA55_5555, 4'h8);
        TestCtrl(i, 32'hAAAA_AAAA, 32'hAAAA_5555, 4'h4);
        TestCtrl(i, 32'hAAAA_AAAA, 32'hAAAA_AA55, 4'h2);
        TestCtrl(i, 32'hAAAA_AAAA, 32'hAAAA_AAAA, 4'h1);
        TestCtrl(i, 32'hCA55_E77E, 32'hCA55_E77E, 4'hF);
    end

    // Test all STAT registers
    $display("%m: Testing STAT registers");
    for (int i=0; i<STAT; i++) begin
        TestStat(i, 32'h5555_5555);
        TestStat(i, 32'hAAAA_AAAA);
        TestStat(i, 32'hDEAD_BEEF);
        TestStat(i, 32'hCA55_E77E);
        TestStat(i, 32'hC0DE_BABE);
        TestStat(i, {i[7:0],i[7:0],i[7:0],i[7:0]});
    end

    // Test all interrupts
    $display("%m: Testing interupts");

    if (!busPass) begin
        $display("%m: Bus failed at some point");
        pass = 1'b0;
    end
    if (pass) begin
        $display("%m: PASS");
    end
    else begin
        $display("%m: FAIL");
    end
    done = 1'b1;
end


/*****************************************************************************/
// UUT
/*****************************************************************************/

AxilCsr #(
    .CTRL          (CTRL          ), ///< Number of control registers
    .STAT          (STAT          ), ///< Number of status registers
    .HAS_INTERRUPTS(HAS_INTERRUPTS), ///< Whether interrupts are present
    .INTERRUPTS    (INTERRUPTS    )  ///< Number of interrupts (up to 32)
)
uut (
    .*
);

endmodule
