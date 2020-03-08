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
# AXI4 Protocol Bus Interface #

Implements an AXI4 bus interface.
*/
interface Axi4
#(
    parameter BYTES    = 4,  ///< Number of bytes in bus
    parameter ADDR_W   = 12, ///< Width of address signals
    parameter ID_WIDTH = 4   ///< Width of ID signals
)
(
    input logic aclk,   ///< Global clock signal
    input logic aresetn ///< Global reset signal, active LOW
);

// We can't have 0-sized signals, so make them 1 bit and assume nothing attached
// to the bus will use them.
localparam ID_WIDTH_     = (ID_WIDTH     < 1) ? 1 : ID_WIDTH    ;

/**************************************************************************/
// AXI4 Write Address Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] awId; ///< Write address ID
logic [ADDR_W-1:0] awAddr;  ///< Write address
logic [7:0] awLen;          ///< Burst length
logic [2:0] awSize;         ///< Burst size
logic [1:0] awBurst;        ///< Burst type
logic awLock;               ///< Lock type
logic [3:0] awCache;        ///< Memory type
logic [2:0] awProt;         ///< Protection type
logic [3:0] awQos;          ///< Quality of Service
logic [3:0] awRegion;       ///< Region ientifier
logic awValid;              ///< Write address valid
logic awReady;              ///< Write address ready

/**************************************************************************/
// AXI4 Write Data Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] wId; ///< Write ID tag
logic [8*BYTES-1:0] wData; ///< Write data
logic [BYTES-1:0] wStrb;   ///< Write strobes
logic wLast;               ///< Write last
logic wValid;              ///< Write valid
logic wReady;              ///< Write ready

/**************************************************************************/
// AXI4 Write Response Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] bId; ///< Response ID tag
logic [1:0] bResp;         ///< Write response
logic bValid;              ///< Write response valid
logic bReady;              ///< Response ready

/**************************************************************************/
// AXI4 Read Address Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] arId; ///< Read address ID
logic [ADDR_W-1:0] arAddr;  ///< Read address
logic [7:0] arLen;          ///< Burst length
logic [2:0] arSize;         ///< Burst size
logic [1:0] arBurst;        ///< Burst type
logic arLock;               ///< Lock type
logic [3:0] arCache;        ///< Memory type
logic [2:0] arProt;         ///< Protection type
logic [3:0] arQos;          ///< Quality of service
logic [3:0] arRegion;       ///< Region identifier
logic arValid;              ///< Read address valid
logic arReady;              ///< Read address ready

/**************************************************************************/
// AXI4 Read Data Channel
/**************************************************************************/

logic [ID_WIDTH_-1:0] rId; ///< Read ID tag
logic [8*BYTES-1:0] rData; ///< Read data
logic [1:0] rResp;         ///< Read response
logic rLast;               ///< Read last
logic rValid;              ///< Read valid
logic rReady;              ///< Read ready

/**************************************************************************/
// AXI4 Low-Power Interface
/**************************************************************************/

// AXI4 Interface Master
modport M (
    // Global Signals
    input  aclk,
    input  aresetn,
    // Write Address Channel
    output awId,
    output awAddr,
    output awLen,
    output awSize,
    output awBurst,
    output awLock,
    output awCache,
    output awProt,
    output awQos,
    output awRegion,
    output awValid,
    input  awReady,
    // Write Data Channel
    output wId,
    output wData,
    output wStrb,
    output wLast,
    output wValid,
    input  wReady,
    // Write Response Channel
    input  bId,
    input  bResp,
    input  bValid,
    output bReady,
    // Read Address Channel
    output arId,
    output arAddr,
    output arLen,
    output arSize,
    output arBurst,
    output arLock,
    output arCache,
    output arProt,
    output arQos,
    output arRegion,
    output arValid,
    input  arReady,
    // Read Data Channel
    input  rId,
    input  rData,
    input  rResp,
    input  rLast,
    input  rValid,
    output rReady
);

// AXI4 Interface Slave
modport S (
    // Global Signals
    input  aclk,
    input  aresetn,
    // Write Address Channel
    input  awId,
    input  awAddr,
    input  awLen,
    input  awSize,
    input  awBurst,
    input  awLock,
    input  awCache,
    input  awProt,
    input  awQos,
    input  awRegion,
    input  awValid,
    output awReady,
    // Write Data Channel
    input  wId,
    input  wData,
    input  wStrb,
    input  wLast,
    input  wValid,
    output wReady,
    // Write Response Channel
    output bId,
    output bResp,
    output bValid,
    input  bReady,
    // Read Address Channel
    input  arId,
    input  arAddr,
    input  arLen,
    input  arSize,
    input  arBurst,
    input  arLock,
    input  arCache,
    input  arProt,
    input  arQos,
    input  arRegion,
    input  arValid,
    output arReady,
    // Read Data Channel
    output rId,
    output rData,
    output rResp,
    output rLast,
    output rValid,
    input  rReady
);

endinterface
