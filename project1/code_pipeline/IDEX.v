module IDEX(
    clk_i,
    WB_i,                   
    M_i,                   
    EX_i,               
    data1_i,           
    data2_i,              
    signextend_i,
    rs_i,
    rt_i,
    rd_i,
    WB_o,
    M_o,
    ALUSrc_o,
    ALUOp_o,
    RegDst_o,
    data1_o,
    data2_o,
    signextend_o,
    rs_o,
    rt_o,
    rd_o
);

input				clk_i;
input	[1:0]		WB_i, M_i;
input	[3:0]		EX_i;
input	[4:0]		rs_i, rt_i, rd_i;
input	[31:0]		data1_i, data2_i, signextend_i;

output	[1:0]		WB_o, M_o;
output	[4:0]		rs_o, rt_o, rd_o;
output	[31:0]		data1_o, data2_o, signextend_o;

output				ALUSrc_o, RegDst_o;
output	[1:0]		ALUOp_o;

reg 	[1:0]		WB_o, M_o;
reg 	[4:0]		rs_o, rt_o, rd_o;
reg 	[31:0]		data1_o, data2_o, signextend_o;

reg 				ALUSrc_o, RegDst_o;
reg 	[1:0]		ALUOp_o;

initial begin
	#10
	WB_o = 0;
	M_o = 0;
	ALUSrc_o = 0;
	ALUOp_o = 2'b00;
	RegDst_o = 0;
	data1_o = 0;
	data2_o = 0;
	signextend_o = 0;
	rs_o = 0;
	rt_o = 0;
	rd_o = 0;
end

always@(posedge clk_i) begin
	WB_o <= WB_i;
	M_o <= M_i;
	ALUSrc_o <= EX_i[3];
	ALUOp_o <= EX_i[2:1];
	RegDst_o <= EX_i[0];
	data1_o <= data1_i;
	data2_o <= data2_i;
	signextend_o <= signextend_i;
	rs_o <= rs_i;
	rt_o <= rt_i;
	rd_o <= rd_i;
end

endmodule