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
