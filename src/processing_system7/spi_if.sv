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
# SPI Interface #

Full SPI signal set, adopted for FPGA use.
*/
interface spi_if
(
);

/// SCLK
logic       SCLKI;  ///< SCLK, input if slave
logic       SCLKO;  ///< SCLK, output if master
logic       SCLKTN; ///< SCLK tri-state: 1=input, 0=output
/// MOSI
logic       SI;     ///< MOSI, input if slave
logic       MO;     ///< MOSI, output if master
logic       MOTN;   ///< MOSI tri-state: 1=input, 0=output
/// MISO
logic       MI;     ///< MISO, input if master
logic       SO;     ///< MISO, output if slave
logic       STN;    ///< MISO tri-state: 1=input, 0=output
/// Slave Select
logic       SSIN;   ///< Slave select, input if slave
logic [2:0] SSON;   ///< Slave selects, outputs if master
logic       SSNTN;  ///< Slave select tri-state: 1=input, 0=output

modport device (
    // SCLK
    input  SCLKI,
    output SCLKO,
    output SCLKTN,
    // MOSI
    input  SI,
    output MO,
    output MOTN,
    // MISO
    input  MI,
    output SO,
    output STN,
    // Slave Select
    input  SSIN,
    output SSON,
    output SSNTN
);

endinterface
