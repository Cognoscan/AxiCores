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
