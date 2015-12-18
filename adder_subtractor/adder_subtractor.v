
module adder_subtractor
#(
    parameter IMPLEMENTATION        = "Fabric",              ///< Implementation - "FABRIC" or "DSP48"
    parameter A_TYPE                = "SIGNED",              ///< A Input Type - "SIGNED" or "UNSIGNED"
    parameter B_TYPE                = "SIGNED",              ///< B Input Type - "SIGNED" or "UNSIGNED"
    parameter A_WIDTH               = 15,                    ///< A Input Width
    parameter B_WIDTH               = 15,                    ///< B Input Width
    parameter ADD_MODE              = "ADD",                 ///< Add Mode - "ADD","SUBTRACT","ADD/SUBTRACT"
    parameter OUT_WIDTH             = 16,                    ///< Output Width
    parameter LATENCY_CONFIGURATION = "MANUAL",              ///< Latency Configuraton - "MANUAL" or "AUTOMATIC"
    parameter LATENCY               = 1,                     ///< Latency - 0,1, or 2
    parameter B_CONSTANT            = "FALSE",               ///< Use Constant Input instead of B - "TRUE" or "FALSE"
    parameter B_VALUE               = 000000000000000,       ///< Constant Value for B
    parameter CE                    = "TRUE"                ///< Use Clock Enable (CE) - "TRUE"or "FALSE"
    parameter C_IN                  = "FALSE",               ///< Use Carry In (C_IN) - "TRUE"or "FALSE"
    parameter C_OUT                 = "FALSE",               ///< Use Carry_Out (C_OUT) - "TRUE"or "FALSE"
    parameter BORROW_SENSE          = "ACTIVE_LOW",          ///< Borrow In/Out Sense - "ACTIVE_LOW"or "ACTIVE_HIGH"
    parameter SCLR                  = "FALSE",               ///< Use Synchronous Clear (SCLR) - "TRUE"or "FALSE"
    parameter SSET                  = "FALSE",               ///< Use Synchronous Set (SSET) - "TRUE" or "FALSE"
    parameter SINIT                 = "FALSE",               ///< Use Synchronous Init (SINIT) - "TRUE" or "FALSE"
    parameter SINIT_VALUE           = 0,                     ///< Init Value for output (Hex)
    parameter BYPASS                = "FALSE",               ///< Use bypass (BYPASS) - "TRUE" or "FALSE"
    parameter BYPASS_SENSE          = "ACTIVE_HIGH",         ///< Bypass Sense - "ACTIVE_HIGH" or "ACTIVE_LOW"
    parameter SYNC_CTRL_PRIORITY    = "RESET_OVERRIDES_SET", ///< Synchronous Set and Clear (Reset) Priority - "RESET_OVERRIDES_SET" or "SET_OVERRIDES_RESET"
    parameter SYNC_CE_PRIORITY      = "SYNC_OVERRIDES_CE",   ///< Synchronous Controls and Clock Enable (CE) - "SYNC_OVERRIDES_CE" or "CE_OVERRIDES_SYNC"
    parameter BYPASS_CE_PRIORITY    = "CE_OVERRIDES_BYPASS", ///< Bypass and Clock Enable (CE) Priority - "CE_OVERRIDES_BYPASS" or "BYPASS_OVERRIDES_CE"
    parameter AINIT_VALUE           = 0                      ///< Power-on Reset Init Value (Hex)
)
(
    input  [A_WIDTH-1:0] A,   ///< A Input Bus
    input  [B_WIDTH-1:0] B,   ///< B Input bus
    input  ADD,               ///< High=add, low=subtract
    input  C_IN,              ///< Carry input
    output C_OUT,             ///< Carry output
    output [OUT_WIDTH-1:0] S, ///< Output bus
    input  BYPASS,            ///< Set to load B into S
    input  CE,                ///< Active-High clock enable
    input  CLK,               ///< System clock, rising edge
    input  SCLR,              ///< Synchronous clear: force output to low
    input  SINIT,             ///< Synchronous set: force output to INIT
    input  SSET               ///< Synchronous set: force output to high
);


initial begin
    if (IMPLEMENTATION != "Fabric" && IMPLEMENTATION != "DSP48") begin
        $display("Attribute Syntax Error : The Attribute IMPLEMENTATION on adder_subtractor instance %m is set to %s.  Legal values for this attribute are FABRIC or DSP48.", IMPLEMENTATION);
        $finish();
    end
    if (A_TYPE != "SIGNED" && A_TYPE != "UNSIGNED") begin
        $display("Attribute Syntax Error : The Attribute A_TYPE on adder_subtractor instance %m is set to %s.  Legal values for this attribute are SIGNED or UNSIGNED.", A_TYPE);
        $finish();
    end
    if (B_TYPE != "SIGNED" && B_TYPE != "UNSIGNED") begin
        $display("Attribute Syntax Error : The Attribute B_TYPE on adder_subtractor instance %m is set to %s.  Legal values for this attribute are SIGNED or UNSIGNED.", B_TYPE);
        $finish();
    end
    if (A_WIDTH < 0) begin
        $display("Attribute Syntax Error : The Attribute A_WIDTH on adder_subtractor instance %m is set to %d.  Legal values for this attribute are 1 or greater.", A_WIDTH);
        $finish();
    end
    if (B_WIDTH < 0) begin
        $display("Attribute Syntax Error : The Attribute B_WIDTH on adder_subtractor instance %m is set to %d.  Legal values for this attribute are 1 or greater.", B_WIDTH);
        $finish();
    end
    if (ADD_MODE != "ADD" && ADD_MODE != "SUBTRACT" && ADD_MODE != "ADD/SUBTRACT") begin
        $display("Attribute Syntax Error : The Attribute ADD_MODE on adder_subtractor instance %m is set to %s.  Legal values for this attribute are ADD, SUBTRACT, or ADD/SUBTRACT.", ADD_MODE);
        $finish();
    end
    if (OUT_WIDTH < 0) begin
        $display("Attribute Syntax Error : The Attribute OUT_WIDTH on adder_subtractor instance %m is set to %d.  Legal values for this attribute are 1 or greater.", OUT_WIDTH);
        $finish();
    end
    if (LATENCY_CONFIGURATION != "MANUAL" && LATENCY_CONFIGURATION != "AUTOMATIC") begin
        $display("Attribute Syntax Error : The Attribute LATENCY_CONFIGURATION on adder_subtractor instance %m is set to %s.  Legal values for this attribute are MANUAL or AUTOMATIC.", LATENCY_CONFIGURATION);
        $finish();
    end
    if (LATENCY < 0 || LATENCY > 2) begin
        $display("Attribute Syntax Error : The Attribute LATENCY on adder_subtractor instance %m is set to %d.  Legal values for this attribute are 0 to 2.", LATENCY);
        $finish();
    end
    if (B_CONSTANT != "FALSE" && B_CONSTANT != "TRUE") begin
        $display("Attribute Syntax Error : The Attribute B_CONSTANT on adder_subtractor instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", B_CONSTANT);
        $finish();
    end





endmodule

