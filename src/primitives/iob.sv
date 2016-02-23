/**
# Generic I/O Buffer #

Provides a device-agnostic, tristate-capable I/O buffer.
*/
module iob #(
    parameter ARCH = "GENERIC"
)
(
    input  wire i,  ///< Input to IOB (used to drive pad)
    input  wire t,  ///< Tristate. 1=drive pad, 0=high impedence
    output wire o,  ///< Output from IOB (value at pad)
    inout  wire pad ///< I/O pad
);

generate

if (ARCH == "GENERIC") begin
    assign o = pad;
    assign pad = t ? o : 1'bz;
end
else if ((ARCH == "XIL_SPARTAN6") || (ARCH == "XIL_VIRTEX6") || (ARCH == "XIL_7SERIES")) begin
    IOBUF io_buffer (
        .I(i),
        .T(t),
        .O(o),
        .IO(pad)
    );
end
else begin
    initial begin
        $display("IOB Module %m does not support ARCH = \"%s\".", ARCH);
        $finish();
    end
end

endgenerate

endmodule
