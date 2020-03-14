module ShortFifo #(
    parameter ADDR_W = 4, ///< 2^ADDR_W is the FIFO size
    parameter DATA_W = 8  ///< Data width
)
(
    input  logic clk,
    input  logic rstn,
    input  logic inValid,          ///< Set when dIn has valid input data
    input  logic outReady,         ///< Set when receiver is ready for data
    input  logic [DATA_W-1:0] dIn, ///< Data into FIFO
    output logic outValid,         ///< High when data available
    output logic inReady,          ///< High when ready for data
    output logic [DATA_W-1:0] dOut ///< Data out of FIFO
);
timeunit 1ns;
timeprecision 10ps;

/*****************************************************************************/
// Parameter Declarations
/*****************************************************************************/

localparam DEPTH = 1<<ADDR_W;

/*****************************************************************************/
// Parameter Validation
/*****************************************************************************/

logic invalidParams;

initial begin
    invalidParams = 1'b0;

    if (ADDR_W < 2) begin
        $error("ShortFifo: ADDR_W must be at least 2, but is %0d. Instance: %m", ADDR_W);
        invalidParams = 1'b1;
    end

    if (DATA_W < 1) begin
        $error("ShortFifo: DATA_W must be at least 1, but is %0d. Instance: %m", DATA_W);
        invalidParams = 1'b1;
    end

    if (invalidParams) begin
        #1 $finish;
    end
end

/*****************************************************************************/
// Signal Declarations
/*****************************************************************************/

logic [ADDR_W-1:0] addr;

logic [DATA_W-1:0] srl [DEPTH-1:0];

logic addrZero;
logic addrMax;
logic localRstn;

enum { ST_EMPTY, ST_OUT, ST_SRL, ST_BOTH } state;

/*****************************************************************************/
// State Machine
/*****************************************************************************/

assign addrZero = ~|addr;
assign addrMax  = &addr;

always_comb begin
    inReady = ~addrMax && localRstn; // Ready as long as SRL isn't full and we're not in reset
    outValid = (state == ST_OUT) || (state == ST_BOTH);
end

always @(posedge clk) begin
    localRstn <= rstn;
end

always @(posedge clk) begin
    if (!localRstn) begin
        addr <= '0;
        state <= ST_EMPTY;
    end
    else begin
        unique case (state)
            ST_EMPTY : state <= inValid ? ST_SRL : ST_EMPTY;
            ST_SRL   : state <= inValid ? ST_BOTH : ST_OUT;
            ST_OUT   : begin
                unique case ({inValid, outReady})
                    2'b00: state <= ST_OUT;
                    2'b01: state <= ST_EMPTY;
                    2'b10: state <= ST_BOTH;
                    2'b11: state <= ST_SRL;
                endcase
            end
            ST_BOTH  : state <= (outReady && !inValid && addrZero) ? ST_OUT : ST_BOTH;
        endcase
        if (state == ST_BOTH) begin
            unique if (inReady && inValid && !outReady) begin
                addr <= addr + 2'd1;
            end
            else if (!(inReady && inValid) && outReady && !addrZero) begin
                addr <= addr - 2'd1;
            end
            else begin
                addr <= addr;
            end
        end
    end
end

/*****************************************************************************/
// Data Path
/*****************************************************************************/

// Normally, we'd initialize the shift register and output register, but for 
// simulation, it's useful to see if invalid data was propagated outside of this 
// module. No consumer of this module should be using dOut unless outValid is 
// high, at which point it shouldn't contain anything invalid.

// Shift register
always @(posedge clk) begin
    if (inValid && inReady) begin
        srl[0] <= dIn;
        for (int i=1; i<DEPTH; i++) begin
            srl[i] <= srl[i-1];
        end
    end
end

// Output register
always @(posedge clk) begin
    if ((outValid && outReady) || (state == ST_SRL)) begin
        dOut <= srl[addr];
    end
end

endmodule
