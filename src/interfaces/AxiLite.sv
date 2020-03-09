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

/**
# AXI4-Lite Protocol Bus Interface #

Implements an AXI4-Lite bus interface.
*/
interface AxiLite
#(
    parameter ADDR_W = 12 ///< Width of address signals
)
(
    input logic aclk,   ///< Global clock signal
    input logic aresetn ///< Global reset signal, active LOW
);
timeunit 1ns;
timeprecision 10ps;

/**************************************************************************/
// AXI4 Write Address Channel
/**************************************************************************/

logic [ADDR_W-1:0] awAddr; ///< Write address
logic [2:0] awProt;        ///< Protection type
logic awValid;             ///< Write address valid
logic awReady;             ///< Write address ready

/**************************************************************************/
// AXI4 Write Data Channel
/**************************************************************************/

logic [31:0] wData; ///< Write data
logic [3:0] wStrb;   ///< Write strobes
logic wValid;              ///< Write valid
logic wReady;              ///< Write ready

/**************************************************************************/
// AXI4 Write Response Channel
/**************************************************************************/

logic [1:0] bResp;         ///< Write response
logic bValid;              ///< Write response valid
logic bReady;              ///< Response ready

/**************************************************************************/
// AXI4 Read Address Channel
/**************************************************************************/

logic [ADDR_W-1:0] arAddr;  ///< Read address
logic [2:0] arProt;         ///< Protection type
logic arValid;              ///< Read address valid
logic arReady;              ///< Read address ready

/**************************************************************************/
// AXI4 Read Data Channel
/**************************************************************************/

logic [31:0] rData; ///< Read data
logic [1:0] rResp;         ///< Read response
logic rValid;              ///< Read valid
logic rReady;              ///< Read ready

// AXI4-Lite Interface Master
modport M (
    // Global Signals
    input  aclk,
    input  aresetn,
    // Write Address Channel
    output awAddr,
    output awProt,
    output awValid,
    input  awReady,
    // Write Data Channel
    output wData,
    output wStrb,
    output wValid,
    input  wReady,
    // Write Response Channel
    input  bResp,
    input  bValid,
    output bReady,
    // Read Address Channel
    output arAddr,
    output arProt,
    output arValid,
    input  arReady,
    // Read Data Channel
    input  rData,
    input  rResp,
    input  rValid,
    output rReady
);

// AXI4-Lite Interface Slave
modport S (
    // Global Signals
    input  aclk,
    input  aresetn,
    // Write Address Channel
    input  awAddr,
    input  awProt,
    input  awValid,
    output awReady,
    // Write Data Channel
    input  wData,
    input  wStrb,
    input  wValid,
    output wReady,
    // Write Response Channel
    output bResp,
    output bValid,
    input  bReady,
    // Read Address Channel
    input  arAddr,
    input  arProt,
    input  arValid,
    output arReady,
    // Read Data Channel
    output rData,
    output rResp,
    output rValid,
    input  rReady
);

task MasterInit;
begin
    awAddr   = '0;
    awProt   = '0;
    awValid  = 1'b0;
    wData    = '0;
    wStrb    = '0;
    wValid   = 1'b0;
    bReady   = 1'b0;
    arAddr   = '0;
    arProt   = '0;
    arValid  = 1'b0;
    rReady   = 1'b0;
end
endtask

task SlaveInit;
begin
    awReady = 1'b0;
    wReady  = 1'b0;
    bResp   = '0;
    bValid  = 1'b0;
    arReady = 1'b0;
    rData   = '0;
    rResp   = '0;
    rValid  = 1'b0;
end
endtask

task Write (
    input longint addr,
    input bit [31:0] data,
    input bit [3:0] strb,
    output bit success
);
bit awDone;
bit wDone;
bit bDone;
begin
    @(negedge aclk)
    awAddr = addr;
    awProt = '0;
    awValid = 1'b1;
    wData = data;
    wStrb = strb;
    wValid = 1'b1;
    awDone = 1'b0;
    wDone = 1'b0;
    while (!awDone || !wDone) begin
        awDone |= awReady;
        wDone |= wReady;
        @(negedge aclk)
        awValid = ~awDone;
        wValid = ~wDone;
    end
    bReady = 1'b1;
    bDone = 1'b0;
    while (!bDone) begin
        bDone |= bValid;
        if (bValid) success = (bResp[1] === 1'b0); // OKAY or EXOKAY
        @(negedge aclk)
        bReady = ~bDone;
    end
end
endtask

task Read (
    input longint addr,
    output bit [31:0] data,
    output bit success
);
bit arDone;
bit rDone;
begin
    @(negedge aclk) 
    arAddr = addr;
    arProt = '0;
    arValid = 1'b1;
    arDone = 1'b0;
    while (!arDone) begin
        arDone |= arReady;
        @(negedge aclk)
        arValid = ~arDone;
    end
    rReady = 1'b1;
    rDone = 1'b0;
    while (!rDone) begin
        rDone |= rValid;
        if (rValid) begin
            data = rData;
            success = (rResp[1] === 1'b0);
        end
        @(negedge aclk)
        rReady = !rDone;
    end
end
endtask

endinterface
