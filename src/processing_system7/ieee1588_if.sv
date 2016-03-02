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
# IEEE 1588 - Precision Time Protocol Interface #

Provides IEEE-1588 signals from the Zynq MAC. The first real user of this 
interface should provide additional documentation on its usage (i.e. provide 
another modport interface).

*/
interface ieee1588_if
(
);

/// TX Timestamp Signals
logic SOFTX;        ///< TX Start of frame
logic DELAYREQTX;   ///< TX Delay request frame detected
logic PDELAYREQTX;  ///< TX Peer delay frame detected
logic PDELAYRESPTX; ///< TX Peer delay response frame detected
logic SYNCFRAMETX;  ///< TX Sync frame detected
/// RX Timestamp Signals
logic SOFRX;        ///< RX Start of frame
logic DELAYREQRX;   ///< RX Delay request frame detected
logic PDELAYREQRX;  ///< RX Peer delay frame detected
logic PDELAYRESPRX; ///< RX Peer delay response frame detected
logic SYNCFRAMERX;  ///< RX Sync frame detected

modport mac (
    // TX
    output SOFTX,
    output DELAYREQTX,
    output PDELAYREQTX,
    output PDELAYRESPTX,
    output SYNCFRAMETX,
    // RX
    output SOFRX,
    output DELAYREQRX,
    output PDELAYREQRX,
    output PDELAYRESPRX,
    output SYNCFRAMERX
);

endinterface
