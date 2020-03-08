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

module AxilBadEndpoint
(
    AxiLite.S bus
);

/*****************************************************************************/
// Write Transaction
/*****************************************************************************/

always_comb begin
    bus.bResp = 2'b11;
end

initial begin
    bus.awReady = 1'b0;
    bus.wReady = 1'b0;
    bus.bValid = 1'b0;
end

always @(posedge bus.aclk) begin
    if (!bus.aresetn) begin
        bus.awReady <= 1'b0;
        bus.wReady  <= 1'b0;
        bus.bValid  <= 1'b0;
    end
    else begin
        // Write Side One-hot state machine
        bus.awReady <= bus.awReady ? ~bus.awValid : ((bus.bValid && bus.bReady) || (!bus.awReady && !bus.wReady && !bus.bValid));
        bus.wReady  <= bus.wReady  ? ~bus.wValid  : (bus.awValid && bus.awReady);
        bus.bValid  <= bus.bValid  ? ~bus.bReady  : (bus.wValid  && bus.wReady);
    end
end

/*****************************************************************************/
// Read Transaction
/*****************************************************************************/

always_comb begin
    bus.rResp = 2'b11;
    bus.rData = '0;
end

initial begin
    bus.arReady = 1'b0;
    bus.rValid = 1'b0;
end

always @(posedge bus.aclk) begin
    if (!bus.aresetn) begin
        bus.arReady <= 1'b0;
        bus.rValid <= 1'b0;
    end
    else begin
        // Read side One-hot state machine
        bus.arReady <= bus.arReady ? ~bus.arValid : ((bus.arValid && bus.arReady) || (!bus.arReady && !bus.rValid));
        bus.rValid  <= bus.rValid  ? ~bus.rReady  : (bus.arValid && bus.arReady);
    end
end

endmodule
