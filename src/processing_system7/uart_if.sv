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
# UART Interface #

Full UART signal set, adopted for FPGA use.
*/
interface uart_if
(
);

/// Data channel
logic RX;           ///< Receive
logic TX;           ///< Transmit
/// Support signals
logic CTSN;         ///< Clear to send
logic DCDN;         ///< Data carrier detect
logic DSRN;         ///< Data set ready
logic RIN;          ///< Ring indicator
logic DTRN;         ///< Data terminal ready
logic RTSN;         ///< Ready to send

modport device (
    // Data channel
    input  RX,
    output TX,
    // Support signals
    input  CTSN,
    input  DCDN,
    input  DSRN,
    input  RIN,
    output DTRN,
    output RTSN
);

endinterface
