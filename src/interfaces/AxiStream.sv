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
# AXI4 Stream Interface #

Implements an AXI4 Stream interface. Some modules may implement a reduced
version of this interface. Namely, many processing modules may only implement
TVALID, TREADY, TDATA, TLAST, and occassionally TUSER. These modules only accept
the "continuous aligned stream" form of AXI4-Stream data, where all bytes are
aligned and the stream will never contain position or null bytes. Any signals
not used by the master shall be set to 0.

*/
interface AxiStream
#(
    parameter WIDTH     = 16, ///< Width of each unit in the stream
    parameter UNITS     = 1,  ///< Number of units in the stream
    parameter SIGNED    = 0,  ///< Whether the data is signed or not
    parameter HAS_TLAST = 0,  ///< Whether TLAST should be observed or not
    parameter TID_W     = 4,  ///< Width of ID bus
    parameter TDEST_W   = 0,  ///< Width of destination bus
    parameter TUSER_W   = 0   ///< Width of user data bus
)
(
    input logic aclk,   ///< Global clock signal
    input logic aresetn ///< Global reset signal, active LOW
);
timeunit 1ns;
timeprecision 10ps;

// We can't have 0-sized signals, so make them 1 bit and assume nothing attached
// to the bus will use the ID / USER signals.
localparam TID_W_   = (TID_W   < 1) ? 1 : TID_W;
localparam TDEST_W_ = (TDEST_W < 1) ? 1 : TDEST_W;
localparam TUSER_W_ = (TUSER_W < 1) ? 1 : TUSER_W;

parameter UNIT_BYTES = WIDTH/8;
parameter BYTES      = UNIT_BYTES * UNITS;

/**************************************************************************/
// Channel
/**************************************************************************/

logic tValid;                   ///< Transfer is valid
logic tReady;                   ///< Slave ready for transfer
logic tLast;                    ///< Packet boundary indicator
logic [8*BYTES-1:0] tData;      ///< Data being sent
logic [BYTES-1:0] tStrb;        ///< 1 for data byte, 0 for position byte
logic [BYTES-1:0] tKeep;        ///< 1 for data stream, 0 for null byte
logic [TID_W_-1:0] tId;     ///< Data stream identifier
logic [TDEST_W_-1:0] tDest; ///< Routing information for data stream
logic [TUSER_W_-1:0] tUser; ///< User-defined sideband information

// AXI4 Stream Master
modport M (
    // Global Signals
    input  aclk,
    input  aresetn,
    // Channel Signals
    output tValid,
    input  tReady,
    output tData,
    output tStrb,
    output tKeep,
    output tLast,
    output tId,
    output tDest,
    output tUser
);

// AXI4 Stream Slave
modport S (
    // Global Signals
    input  aclk,
    input  aresetn,
    // Channel Signals
    input  tValid,
    output tReady,
    input  tData,
    input  tStrb,
    input  tKeep,
    input  tLast,
    input  tId,
    input  tDest,
    input  tUser
);

endinterface
