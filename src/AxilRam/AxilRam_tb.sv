module AxilRam_tb #(
    parameter MEM_W = 10
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

/*****************************************************************************/
// Signal Declarations
/*****************************************************************************/

logic clk;
logic rstn;

bit busSuccess;
bit busPass;

logic [31:0] writeData;
logic [31:0] readData;
logic [MEM_W+1:0] addr;
logic [31:0] testReg;
logic [3:0] testStrb;

AxiLite #(MEM_W+2) bus (clk, rstn);

/*****************************************************************************/
// Test Code
/*****************************************************************************/

always #1 if ((start !== 1'b0) && !done) clk = ~clk;

initial begin
    clk = 1'b0;
    rstn = 1'b0;
    done = 1'b0;
    pass = 1'b1;
    busPass = 1'b1;
    bus.MasterInit;
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b1;

    // Simple test: write data to registers & read it back
    bus.Write(8'h00, 32'hCA55E77E, 4'hF, busSuccess); busPass &= busSuccess;
    bus.Write(8'h04, 32'hDEADBEEF, 4'hF, busSuccess); busPass &= busSuccess;
    bus.Write(8'h08, 32'h1337D00D, 4'hF, busSuccess); busPass &= busSuccess;

    #50 // Give time for contents to flush to the RAM

    bus.Read(8'h00, readData, busSuccess); busPass &= busSuccess;
    if (readData != 32'hCA55E77E) begin
        pass = 1'b0;
        $display("%m: At address 0, expected %x, got %x", 32'hCA55E77E, readData);
    end
    bus.Read(8'h04, readData, busSuccess); busPass &= busSuccess;
    if (readData != 32'hDEADBEEF) begin
        pass = 1'b0;
        $display("%m: At address 4, expected %x, got %x", 32'hDEADBEEF, readData);
    end
    bus.Read(8'h08, readData, busSuccess); busPass &= busSuccess;
    if (readData != 32'h1337D00D) begin
        pass = 1'b0;
        $display("%m: At address 8, expected %x, got %x", 32'h1337D00D, readData);
    end

    for (int i=0; i<1024; i++) begin
        addr = $random; // Let lower address bits be whatever - slave should ignore them
        testStrb = $random;
        writeData = $random;
        bus.Read(addr, readData, busSuccess); busPass &= busSuccess;
        testReg = writeData;
        if (!testStrb[0]) testReg[ 7: 0] = readData[ 7: 0];
        if (!testStrb[1]) testReg[15: 8] = readData[15: 8];
        if (!testStrb[2]) testReg[23:16] = readData[23:16];
        if (!testStrb[3]) testReg[31:24] = readData[31:24];
        bus.Write(addr, writeData, testStrb, busSuccess); busPass &= busSuccess;
        #50 // Give time for contents to flush to the RAM
        bus.Read(addr, readData, busSuccess); busPass &= busSuccess;
        if (readData != testReg) begin
            pass = 1'b0;
            $display("%m: At address %x, wrote %x with %x strobes, expected %x, got %x",
                addr, writeData, testStrb, testReg, readData
            );
            break;
        end
    end

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

AxiLite #(MEM_W+2) busReg (clk, rstn);
AxilReg #(1) busRegister (bus, busReg);

AxilRam #(
    .MEM_W(MEM_W)
)
uut (
    .bus(busReg)
);

endmodule
