module DualRamBe #(
    parameter ADDR_W = 10,
    parameter DATA_W = 32
)
(
    input  logic aClk,
    input  logic [ADDR_W-1:0] aAddr,
    input  logic [DATA_W-1:0] aWrite,
    input  logic [(DATA_W+7)/8-1:0] aStrb,
    input  logic aEn,
    input  logic bClk,
    output logic [DATA_W-1:0] aRead,
    input  logic [ADDR_W-1:0] bAddr,
    input  logic [DATA_W-1:0] bWrite,
    input  logic [(DATA_W+7)/8-1:0] bStrb,
    input  logic bEn,
    output logic [DATA_W-1:0] bRead
);

localparam SIZE = 1 << ADDR_W;
localparam STRB_W = (DATA_W+7)/8;

logic [DATA_W-1:0] ram [SIZE-1:0];

initial begin
    for (int i=0; i<SIZE; i++) begin
        ram[i] = '0;
    end
end

always @(posedge aClk) begin
    if (aEn) begin
        for (int i=0; i<STRB_W; i++) begin
            if (aStrb[i]) ram[aAddr][(8*i)+:8] = aWrite[(8*i)+:8];
        end
        aRead = ram[aAddr];
    end
end

always @(posedge bClk) begin
    if (bEn) begin
        for (int i=0; i<STRB_W; i++) begin
            if (bStrb[i]) ram[bAddr][(8*i)+:8] = bWrite[(8*i)+:8];
        end
        bRead = ram[bAddr];
    end
end

endmodule
