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

interface axi_hp_fifo_if
(
);

logic [5:0] WACOUNT;       ///< Write address FIFO fill level
logic [7:0] WCOUNT;        ///< Write data FIFO fill level
logic [2:0] RACOUNT;       ///< Read address FIFO fill level
logic [7:0] RCOUNT;        ///< Read data FIFO fill level
logic       RDISSUECAP1EN; ///< Read-issuing capability of AXI FIFO interface
logic       WRISSUECAP1EN; ///< Read-issuing capability of AXI FIFO interface

modport master (
    input  WACOUNT,
    input  WCOUNT,
    input  RACOUNT,
    input  RCOUNT,
    output RDISSUECAP1EN,
    output WRISSUECAP1EN
);
    
modport slave (
    output WACOUNT,
    output WCOUNT,
    output RACOUNT,
    output RCOUNT,
    input  RDISSUECAP1EN,
    input  WRISSUECAP1EN
);

endinterface
