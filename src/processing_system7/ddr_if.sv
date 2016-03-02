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
# DDR Interface #

Make sure to connect DDR_VRP to a resistor to ground, and DDR_VRN to a resistor to VCC_DDR.
*/
interface ddr_if
(
    input  logic [3:0] ARB ///< Optional fabric urgent bits
);

// DDR
wire        CKP;   ///< Differential clock+
wire        CKN;   ///< Differential clock-
wire        CKE;   ///< Clock enable
wire        CSB;   ///< Chip select
wire        RASB;  ///< Row address strobe
wire        CASB;  ///< Column address strobe
wire        WEB;   ///< Write enable
wire  [2:0] BA;    ///< Bank address
wire [14:0] A;     ///< DDR3/DDR3L/DDR2: Row/Column Address. LPDDR2: CA[9:0] = A[9:0]
wire        ODT;   ///< Output dynamic termination signal
wire        DRSTB; ///< Reset
wire [31:0] DQ;    ///< Data bus
wire  [3:0] DM;    ///< Data byte masks
wire  [3:0] DQSP;  ///< Differential data strobes+
wire  [3:0] DQSN;  ///< Differential data strobes-
wire        VRP;   ///< DCI voltage reference+
wire        VRN;   ///< DCI voltage reference-

modport controller (
    // Input
    input ARB,
    // Bidirectional
    inout CKP,
    inout CKN,
    inout CKE,
    inout CSB,
    inout RASB,
    inout CASB,
    inout WEB,
    inout BA,
    inout A,
    inout ODT,
    inout DRSTB,
    inout DQ,
    inout DM,
    inout DQSP,
    inout DQSN,
    inout VRP,
    inout VRN
);

endinterface
