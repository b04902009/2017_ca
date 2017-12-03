module MEMWB(
    clk_i,
    WB_i,
    addr_i,
    data_i,
    rd_i,
    MemtoReg_o,
    RegWrite_o,
    addr_o,
    data_o,
    rd_o
);

input               clk_i;
input	[1:0]	    WB_i;
input	[4:0]	    rd_i;
input   [31:0]      addr_i, data_i;
output              MemtoReg_o, RegWrite_o;
output  [4:0]       rd_o;
output 	[31:0]      addr_o, data_o;

reg                 MemtoReg_o, RegWrite_o;
reg     [4:0]       rd_o;
reg     [31:0]      addr_o, data_o;


initial begin
#20
	MemtoReg_o <= 0;
    RegWrite_o <= 0;
	addr_o <= 0;
	data_o <= 0;
	rd_o <= 0;
end

always@(posedge clk_i) begin
	MemtoReg_o <= WB_i[0];
	RegWrite_o <= WB_i[1];
	addr_o <= addr_i;
	data_o <= data_i;
	rd_o <= rd_i;
end

endmodule