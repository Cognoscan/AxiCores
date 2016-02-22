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
