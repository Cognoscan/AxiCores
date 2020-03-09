module HandshakeReg_tb #(
    parameter FULL = 1,
    parameter W = 16
)
(
    input  logic start,
    output logic done,
    output logic pass
);
timeunit 1ns;
timeprecision 10ps;

logic clk;
logic rstn;
logic inValid;
logic outReady;
logic inReady;
logic outValid;
logic [W-1:0] dIn;
logic [W-1:0] dOut;
logic randIn;
logic randOut;

logic [W-1:0] outCompare;

always #1 if ((start !== 1'b0) && !done) clk = !clk;

initial begin
    done       = 1'b0;
    pass       = 1'b1;
    clk        = 1'b0;
    rstn       = 1'b0;
    inValid    = 1'b0;
    outReady   = 1'b0;
    dIn        = '0;
    randIn     = 1'b1;
    randOut    = 1'b0;
    outCompare = '0;
    dIn = dIn -1; // Subtract 1 to ensure 1st datum is 0
    @(posedge clk) rstn = 1'b0;
    wait (start !== 1'b0);
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b1;
end

always @(posedge clk) begin
    randIn <= $random;
    if (inReady) begin
        if (randIn) begin
            dIn <= dIn + 2'd1;
            inValid <= 1'b1;
        end
        else begin
            inValid <= 1'b0;
        end
    end
    else if (!inValid && randIn) begin
        dIn <= dIn + 2'd1;
        inValid <= 1'b1;
    end
end

int timeout;

always @(posedge clk) begin
    randOut <= $random;
    outReady <= randOut;
    if (outReady && outValid) begin
        timeout <= '0;
        outCompare <= outCompare + 2'd1;
        if (dOut != outCompare) begin
            pass <= 1'b0;
            done <= 1'b1;
            $display("%m: Output mismatch. Expected %d, got %d", outCompare, dOut);
            $display("%m: FAIL");
        end
        if (&outCompare) begin
            done <= 1'b1;
            $display("%m: PASS");
        end
    end
    else begin
        timeout <= timeout + 1;
        if (timeout > 1000) begin
            pass <= 1'b0;
            done <= 1'b1;
            $display("%m: Timeout waiting for data. Giving up.");
            $display("%m: FAIL");
        end
    end
end

HandshakeReg #(
    .FULL(FULL),
    .W(W)
)
uut (
    .*
);

endmodule
