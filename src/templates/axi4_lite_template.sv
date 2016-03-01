/**
# AXI4-Lite Template

Implements the bare minimum AXI4-Lite interface. Provides a single pair of 
registers to illustrate how an AXI4-Lite slave can be built.

## Features ##
- AXI4-Lite Interface
- Maximum Read/Write rate is ACLK/4
- Extensible to any number of registers
- Read and write strobes are generated locally

## Notes ##

When allocating your address space, be aware that addresses must be 32-bit 
aligned. This effectively means that the lower 2 address bits must be 0.

## Expected LUT Usage ##

### Xilinx 6-Input LUT Architectures ###

Assuming all registers are 32 bits wide, we get
`5 + 18*WRITE_REGS + 8*READ_REGS`.

- 2 for strobe logic
- 1 for local reset
- 2 for *VALID signals
- Per Write Register:
    - 2 for address decode
    - 0.5 * NUM_BITS for registering bits
- Read Mux - NUM_REGS/4 * 32, for NUM_REGS in {2,4,8,16,32}.

*/

module axi4_lite_template
#(
    parameter ADDR_WIDTH = 8 ///< Must match s_axi.ADDR_WIDTH
)
(
    axi4_lite_if.slave s_axi ///< AXI4-Lite slave interface
);

/**************************************************************************/
// Parameter Declarations
/**************************************************************************/

localparam REG_REG0 = 'h00;
localparam REG_REG1 = 'h04;

/**************************************************************************/
// Signal Declarations
/**************************************************************************/

logic [ADDR_WIDTH-1:0] w_addr;
logic [ADDR_WIDTH-1:0] r_addr;

logic [31:0] reg0;
logic [31:0] reg1;

logic clk;
logic rst; // Active high
logic write_strobe;
logic read_strobe;

logic write_reg0;
logic write_reg1;

/**************************************************************************/
// Parameter Checking
/**************************************************************************/

initial begin
    if (ADDR_WIDTH != s_axi.ADDR_WIDTH) begin
        $display("AXI Parameter Error: Module %m has ADDR_WIDTH=%d, but AXI ADDR_WIDTH=%d. They must be equal.",
            ADDR_WIDTH, s_axi.ADDR_WIDTH);
        $finish();
    end
end

/**************************************************************************/
// Clock & Reset Logic
/**************************************************************************/

assign clk = s_axi.ACLK;

// Register reset for local use
always_ff @(posedge clk) begin
    rst <= ~s_axi.ARESETn;
end

/**************************************************************************/
// Write Channel
/**************************************************************************/
assign write_strobe = s_axi.AWVALID && s_axi.WVALID && !s_axi.BVALID;
assign w_addr = {s_axi.AWADDR[ADDR_WIDTH-1:2], 2'b00};

assign s_axi.BRESP = 2'b00; // Always respond with RESP_OKAY

assign write_reg0 = (w_addr == REG_REG0);
assign write_reg1 = (w_addr == REG_REG1);

// Registers
always_ff @(posedge clk) begin
    if (rst) begin
        reg0 <= '0;
        reg1 <= '0;
    end
    else begin
        if (write_strobe) begin
            // Register 0
            if (write_reg0 && s_axi.WSTRB[0]) reg0[ 7: 0] <= s_axi.WDATA[ 7: 0];
            if (write_reg0 && s_axi.WSTRB[1]) reg0[15: 8] <= s_axi.WDATA[15: 8];
            if (write_reg0 && s_axi.WSTRB[2]) reg0[23:16] <= s_axi.WDATA[23:16];
            if (write_reg0 && s_axi.WSTRB[3]) reg0[31:24] <= s_axi.WDATA[31:24];
            // Register 1
            if (write_reg1 && s_axi.WSTRB[0]) reg1[ 7: 0] <= s_axi.WDATA[ 7: 0];
            if (write_reg1 && s_axi.WSTRB[1]) reg1[15: 8] <= s_axi.WDATA[15: 8];
            if (write_reg1 && s_axi.WSTRB[2]) reg1[23:16] <= s_axi.WDATA[23:16];
            if (write_reg1 && s_axi.WSTRB[3]) reg1[31:24] <= s_axi.WDATA[31:24];
        end
    end
end

// AXI Write Channel Controls
always_ff @(posedge clk) begin
    if (rst) begin
        s_axi.AWREADY <= 1'b0;
        s_axi.WREADY  <= 1'b0;
        s_axi.BVALID  <= 1'b0;
    end
    else begin
        s_axi.AWREADY <= write_strobe;
        s_axi.WREADY  <= write_strobe;
        // Write Response Channel
        if (write_strobe) begin
            s_axi.BVALID  <= 1'b1;
        end
        else if (s_axi.BVALID) begin
            s_axi.BVALID  <= ~s_axi.BREADY;
        end
    end
end

/**************************************************************************/
// Read Channel
/**************************************************************************/

assign read_strobe = s_axi.ARVALID && !s_axi.RVALID;

assign s_axi.RRESP = 2'b00; // Always respond with RESP_OKAY

assign r_addr = {s_axi.ARADDR[ADDR_WIDTH-1:2], 2'b00};

always_ff @(posedge clk) begin
    if (rst) begin
        s_axi.ARREADY <= '0;
        s_axi.RDATA   <= '0;
        s_axi.RVALID  <= '0;
    end
    else begin
        s_axi.ARREADY <= read_strobe;
        if (read_strobe) begin
            unique case (r_addr)
                REG_REG0 : s_axi.RDATA <= reg0;
                REG_REG1 : s_axi.RDATA <= reg1;
                default  : s_axi.RDATA <= 'h0;
            endcase
        end

        if (read_strobe) begin
            s_axi.RVALID <= 1'b1;
        end
        else if (s_axi.RVALID) begin
            s_axi.RVALID <= ~s_axi.RREADY;
        end
    end
end

endmodule
/* vim: set fdm=marker: */
