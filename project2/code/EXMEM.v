module EXMEM(
    clk_i,
    rst_i,
    WB_i,
    M_i,
    addr_i,
    data_i,
    rd_i,
    WB_o,
    M_o,
    addr_o,
    data_o,
    rd_o
);

input               clk_i, rst_i;
input   [1:0]       WB_i, M_i;
input   [4:0]       rd_i;
input   [31:0]      addr_i, data_i;
output  [1:0]       M_o, WB_o;
output  [4:0]       rd_o;
output  [31:0]      addr_o, data_o;

reg     [1:0]       M_o, WB_o;
reg     [4:0]       rd_o;
reg     [31:0]      addr_o, data_o;


always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        WB_o <= 0;
        M_o <= 0;
        addr_o <= 0;
        data_o <= 0;
        rd_o <= 0;
    end
    else begin
        WB_o <= WB_i;
        M_o <= M_i;
        addr_o <= addr_i;
        data_o <= data_i;
        rd_o <= rd_i;
    end
end

endmodule
