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
# AXI4 Stream Interface #

Implements an AXI4 Stream interface. Some modules may implement a reduced
version of this interface. Namely, many processing modules may only implement
TVALID, TREADY, TDATA, TLAST, and occassionally TUSER. These modules only accept
the "continuous aligned stream" form of AXI4-Stream data, where all bytes are
aligned and the stream will never contain position or null bytes. Any signals
not used by the master shall be set to 0.

*/
interface axi4_stream_if
#(
    parameter N_BYTES     = 4, ///< Number of bytes in bus
    parameter TID_WIDTH   = 4, ///< Width of ID bus
    parameter TDEST_WIDTH = 0, ///< Width of destination bus
    parameter TUSER_WIDTH = 0  ///< Width of user data bus
)
(
    input logic ACLK, ///< Global clock signal
    input logic ARESETn ///< Global reset signal, active LOW
);

// We can't have 0-sized signals, so make them 1 bit and assume nothing attached
// to the bus will use the ID / USER signals.
localparam TID_WIDTH_   = (TID_WIDTH   < 1) ? 1 : TID_WIDTH;
localparam TDEST_WIDTH_ = (TDEST_WIDTH < 1) ? 1 : TDEST_WIDTH;
localparam TUSER_WIDTH_ = (TUSER_WIDTH < 1) ? 1 : TUSER_WIDTH;

/**************************************************************************/
// Channel
/**************************************************************************/

logic                    TVALID; ///< Transfer is valid
logic                    TREADY; ///< Slave ready for transfer
logic    [8*N_BYTES-1:0] TDATA;  ///< Data being sent
logic      [N_BYTES-1:0] TSTRB;  ///< 1 for data byte, 0 for position byte
logic      [N_BYTES-1:0] TKEEP;  ///< 1 for data stream, 0 for null byte
logic                    TLAST;  ///< Packet boundary indicator
logic   [TID_WIDTH_-1:0] TID;    ///< Data stream identifier
logic [TDEST_WIDTH_-1:0] TDEST;  ///< Routing information for data stream
logic [TUSER_WIDTH_-1:0] TUSER;  ///< User-defined sideband information

// AXI4 Stream Master
modport master (
    // Global Signals
    input  ACLK,
    input  ARESETn,
    // Channel Signals
    output TVALID,
    input  TREADY,
    output TDATA,
    output TSTRB,
    output TKEEP,
    output TLAST,
    output TID,
    output TDEST,
    output TUSER
);

// AXI4 Stream Slave
modport slave (
    // Global Signals
    input  ACLK,
    input  ARESETn,
    // Channel Signals
    input  TVALID,
    output TREADY,
    input  TDATA,
    input  TSTRB,
    input  TKEEP,
    input  TLAST,
    input  TID,
    input  TDEST,
    input  TUSER
);

endinterface
