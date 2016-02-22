/**
# JTAG Interface #

JTAG Signal set, with tri-stateable TDO.
*/

interface jtag_if
(
);

logic TMS;  ///< Test mode select
logic TCK;  ///< Test clock
logic TDI;  ///< Test data in
logic TDO;  ///< Test data out
logic TDTN; ///< Test data out tri-state: 1=Hi-Z, 0=output

modport device (
    input  TMS,
    input  TCK,
    input  TDI,
    output TDO,
    output TDTN
);

endinterface
