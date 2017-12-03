module EXMEM(
    clk_i,
    WB_i,
    M_i,
    addr_i,
    data_i,
    rd_i,
    WB_o,
    MemRead_o,
    MemWrite_o,
    addr_o,
    data_o,
    rd_o
);

input               clk_i;
input   [1:0]       WB_i, M_i;
input   [4:0]       rd_i;
input   [31:0]      addr_i, data_i;
output              MemRead_o, MemWrite_o;
output  [1:0]       WB_o;
output  [4:0]       rd_o;
output  [31:0]      addr_o, data_o;

reg                 MemRead_o, MemWrite_o;
reg     [1:0]       WB_o;
reg     [4:0]       rd_o;
reg     [31:0]      addr_o, data_o;

initial begin
#15
    WB_o <= 0;
    MemRead_o <= 0;
    MemWrite_o <= 0;
    addr_o <= 0;
    data_o <= 0;
    rd_o <= 0;
end

always@(posedge clk_i) begin
    WB_o <= WB_i;
    MemRead_o <= M_i[1];
    MemWrite_o <= M_i[0];
    addr_o <= addr_i;
    data_o <= data_i;
    rd_o <= rd_i;
end

endmodule