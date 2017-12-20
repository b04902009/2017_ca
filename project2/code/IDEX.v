module IDEX(
    clk_i,
    rst_i,
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
    EX_o,
    data1_o,
    data2_o,
    signextend_o,
    rs_o,
    rt_o,
    rd_o
);

input				clk_i, rst_i;
input	[1:0]		WB_i, M_i;
input	[3:0]		EX_i;
input	[4:0]		rs_i, rt_i, rd_i;
input	[31:0]		data1_i, data2_i, signextend_i;

output	[1:0]		WB_o, M_o;
output	[4:0]		rs_o, rt_o, rd_o;
output	[31:0]		data1_o, data2_o, signextend_o;
output	[3:0]		EX_o;

reg 	[1:0]		WB_o, M_o;
reg 	[4:0]		rs_o, rt_o, rd_o;
reg 	[31:0]		data1_o, data2_o, signextend_o;
reg		[3:0]		EX_o;


always@(posedge clk_i or negedge rst_i) begin
	if(~rst_i) begin
		WB_o <= 0;
		M_o <= 0;
		EX_o <= 0;
		data1_o <= 0;
		data2_o <= 0;
		signextend_o <= 0;
		rs_o <= 0;
		rt_o <= 0;
		rd_o <= 0;
	end
	else begin
		WB_o <= WB_i;
		M_o <= M_i;
		EX_o <= EX_i;
		data1_o <= data1_i;
		data2_o <= data2_i;
		signextend_o <= signextend_i;
		rs_o <= rs_i;
		rt_o <= rt_i;
		rd_o <= rd_i;
	end
end

endmodule
