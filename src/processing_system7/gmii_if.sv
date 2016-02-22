/**
# GMII Interface for Ethernet #

The GMII Interface w/ MDIO signals.

For MDIO, the signals have been modified to suit an FPGA, where bidirectional 
lines do not exist. Names are assigned from the perspective of the MAC. If the 
PHY and MAC are both in the FPGA, one may ignore the `MDIO_*_TN` signals. If the 
PHY or MAC is off-chip, they are necessary for creating the tristate I/O buffer 
for the MDIO signal.
*/
interface gmii_if 
(
    input logic GTX_CLK ///< Transmit Clock
);

// RX Channel
logic [7:0] RXD;         ///< Receive data
logic       RX_CLK;      ///< Receive clock
logic       RX_DV;       ///< Receive data valid
logic       RX_ER;       ///< Receive error
// TX Channel
logic [7:0] TXD;         ///< Transmit data
logic       TX_EN;       ///< Transmit enable
logic       TX_ER;       ///< Transmit error
// Control Signals
logic       COL;         ///< Collision Detect
logic       CRS;         ///< Carrier Sense
// Management (MDIO)
logic       MDIO_I;      ///< MDIO Data from PHY to MAC
logic       MDIO_MDC;    ///< MDIO Clock
logic       MDIO_O;      ///< MDIO Data from MAC to PHY
logic       MDIO_MAC_TN; ///< MDIO MAC Tristate (1=Receive, 0=Transmit)
logic       MDIO_PHY_TN; ///< MDIO PHY Tristate (1=Receive, 0=Transmit)

// MAC interface
modport mac (
    // RX Channel
    input  RXD,
    input  RX_CLK,
    input  RX_DV,
    input  RX_ER,
    // TX Channel
    output TXD,
    input  GTX_CLK,
    output TX_EN,
    output TX_ER,
    // Control Signals
    input  COL,
    input  CRS,
    // Management
    output MDIO_MDC,
    output MDIO_O,
    output MDIO_MAC_TN,
    output MDIO_I
    );

// PHY interface
modport phy (
    // RX Channel
    output RXD,
    output RX_CLK,
    output RX_DV,
    output RX_ER,
    // TX Channel
    input  TXD,
    input  GTX_CLK,
    input  TX_EN,
    input  TX_ER,
    // Control Signals
    output COL,
    output CRS,
    // Management
    input  MDIO_MDC,
    input  MDIO_O,
    output MDIO_I,
    output MDIO_PHY_TN
    );

endinterface
