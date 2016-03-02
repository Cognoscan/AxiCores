/*
   Copyright 2016 Scott Teal

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
