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
