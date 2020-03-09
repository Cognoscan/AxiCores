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

module HandshakeReg #(
    parameter FULL = 0, ///< Set for full clock rate, leave 0 for half clock rate (less logic)
    parameter W    = 1  ///< Data width
)
(
    input logic clk,          ///< System clock
    input logic rstn,         ///< Reset, synchronous and active low
    input logic inValid,      ///< Set when dIn has valid input data
    input logic outReady,     ///< Set when receiver is ready for data
    input logic [W-1:0] dIn,  ///< Data into reg
    output logic outValid,    ///< High when data available
    output logic inReady,     ///< High when ready for data
    output logic [W-1:0] dOut ///< Data reg out
);
timeunit 1ns;
timeprecision 10ps;

initial begin
    outValid = 1'b0;
    inReady  = 1'b0;
    dOut     = '0;
end

if (!FULL) begin
    
    always @(posedge clk) begin
        if (!rstn) begin
            outValid <= 1'b0;
            inReady  <= 1'b0;
        end
        else begin
            inReady  <= inReady  ? ~inValid  : ((outValid && outReady) || (!inReady && !outValid));
            outValid <= outValid ? ~outReady :  (inValid  && inReady);
        end
    end
    
    always @(posedge clk) begin
        // Register on validated input
        if (inValid && inReady) begin
            dOut <= dIn;
        end
    end
end
else begin
    
    // Skid buffer registers
    logic [W-1:0] buffer = '0;
    logic bufferFull = 1'b0;

    // State Logic
    always @(posedge clk) begin
        if (!rstn) begin
            outValid <= 1'b0;
            inReady  <= 1'b0;
            bufferFull <= 1'b0;
        end
        else begin
            inReady <= inReady
                ? !(inValid && outValid && !outReady) // Stop being ready when we have incoming data that can't be moved to output
                : ((!inReady && !outValid && !bufferFull) // Set when coming out of initial state
                  || (outValid && outReady));
            outValid <= outValid
                ? !(outReady && !bufferFull && !(inValid && inReady)) // No valid data if data is leaving, nothing is in buffer, and nothing is coming in
                : (inValid && inReady); // Valid data once something is coming in
            bufferFull <= bufferFull
                ? !(outValid && outReady) // Buffer empties once data leaves output
                : (inValid && inReady && outValid && !outReady); // Buffer fills when incoming data can't go to output
        end
    end

    always @(posedge clk) begin
        // Skid buffer
        // Updates when we have incoming data that can't go right to outgoing data register
        if (inValid && inReady && outValid && !outReady) begin
            buffer <= dIn;
        end
        // Output buffer. Updates when:
        if ((inValid && inReady && !outValid) // Incoming data, nothing going out yet
            || (inValid && inReady && outValid && outReady) // Incoming data will replace outgoing data
            || (outValid && outReady && bufferFull)) // Outgoing data and we have buffered data
        begin
            dOut <= bufferFull ? buffer : dIn;
        end
    end
end

endmodule
