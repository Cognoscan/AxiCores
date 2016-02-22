/**
# Secure Digital - SDIO Interface #

Full Zynq signal set for SDIO.
*/
interface sdio_if
(
);

logic       CLK;     ///< Clock
logic       CLKFB;   ///< Clock feedback
logic       CMDI;    ///< Command (input)
logic       CMDO;    ///< Command (output)
logic       CMDTN;   ///< Command (tri-state control, 1=Hi-Z, 0=output)
logic [3:0] DATAI;   ///< Data (input)
logic [3:0] DATAO;   ///< Data (output)
logic [3:0] DATATN;  ///< Data (tri-state control, 1=Hi-Z, 0=output)
logic [2:0] BUSVOLT; ///< Bus voltage
logic       BUSPOW;  ///< Power control
logic       CDN;     ///< Card detect, active low
logic       LED;     ///< LED control
logic       WP;      ///< Write protect detection

modport master (
    // Clock
    output CLK,
    input  CLKFB,
    // Command Channel
    input  CMDI,
    output CMDO,
    output CMDTN,
    // Data Channel
    input  DATAI,
    output DATAO,
    output DATATN,
    // Auxilliary signals
    output BUSVOLT,
    output BUSPOW,
    input  CDN,
    output LED,
    input  WP
);

endinterface
