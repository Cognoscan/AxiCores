/**
# I2C Interface #

Full I2C signal set, adopted for FPGA use.
*/
interface i2c_if
(
);

logic SCLI;  ///< Clock in
logic SCLO;  ///< Clock out
logic SCLTN; ///< Clock tri-state: 1=Hi-Z, 0=output
logic SDAI;  ///< Data in
logic SDAO;  ///< Data out
logic SDATN; ///< Data tri-state: 1=Hi-Z, 0=output

modport device (
    input  SCLI,
    output SCLO,
    output SCLTN,
    input  SDAI,
    output SDAO,
    output SDATN
);

endinterface
