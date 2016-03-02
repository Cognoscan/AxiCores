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
