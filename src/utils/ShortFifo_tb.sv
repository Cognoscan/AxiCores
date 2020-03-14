module ShortFifo_tb #(
    parameter ADDR_W = 4, ///< 2^ADDR_W is the FIFO size
    parameter DATA_W = 16 ///< Data width
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

localparam TIMEOUT = 1000; // Maximum number of cycles to wait before giving up

/*****************************************************************************/
// UUT Signal Declarations
/*****************************************************************************/

logic clk;
logic rstn;
logic inValid;           ///< Set when dIn has valid input data
logic outReady;          ///< Set when receiver is ready for data
logic [DATA_W-1:0] dIn;  ///< Data into FIFO
logic outValid;          ///< High when data available
logic inReady;           ///< High when ready for data
logic [DATA_W-1:0] dOut; ///< Data out of FIFO

/*****************************************************************************/
// Test Signal Declarations
/*****************************************************************************/

bit [ADDR_W-1:0] randIn;
bit [ADDR_W-1:0] randOut;
logic [DATA_W-1:0] outCompare;

/*****************************************************************************/
// Test Code
/*****************************************************************************/

always #1 if ((start !== 1'b0) && !done) clk = !clk;

initial begin
    done       = 1'b0;
    pass       = 1'b1;
    clk        = 1'b0;
    rstn       = 1'b0;
    inValid    = 1'b1;
    outReady   = 1'b1;
    dIn        = '0;
    randIn     = 1;
    randOut    = 1;
    outCompare = '0;
    @(posedge clk) rstn = 1'b0;
    wait (start !== 1'b0);
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b0;
    @(posedge clk) rstn = 1'b1;
end

/*****************************************************************************/
// Send Tester
/*****************************************************************************/

always @(posedge clk) begin
    // Send a burst of size randIn, then rest for randIn cycles
    if (inValid) begin
        if (inReady) begin
            dIn <= dIn + 2'd1;
            if (randIn == 0) begin
                inValid <= 1'b0;
                randIn <= $random;
            end
            else begin
                randIn <= randIn - 1;
            end
        end
    end
    else begin
        if (randIn == 0) begin
            inValid <= 1'b1;
            randIn <= $random;
        end
        else begin
            randIn <= randIn - 1;
        end
    end
end

/*****************************************************************************/
// Receive Tester
/*****************************************************************************/

int timeout;

always @(posedge clk) begin
    if (outReady) begin
        if (outValid) begin
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
            timeout <= '0;
            outCompare <= outCompare + 2'd1;
            if (randOut == 0) begin
                outReady <= 1'b0;
                randOut <= $random;
            end
            else begin
                randOut <= randOut - 1;
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
    else begin
        if (randOut == 0) begin
           outReady <= 1'b1; 
           randOut <= $random;
       end
       else begin
           randOut <= randOut - 1;
       end
    end
end

/*****************************************************************************/
// Unit Under Test
/*****************************************************************************/

ShortFifo #(
    .ADDR_W(ADDR_W), ///< 2^ADDR_W is the FIFO size
    .DATA_W(DATA_W)  ///< Data width
)
uut (
    .*
);

endmodule
