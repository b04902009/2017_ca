module MUX_Jump(
    data1_28_i,
    data1_32_i,
    data2_i,
    select_i,
    data_o
);

input	[27:0]		data1_28_i;
input	[31:0]		data1_32_i, data2_i;
input				select_i;
output	[31:0]		data_o;

reg		[31:0]		data1, data_o;

always @(data1_28_i or data1_32_i or data2_i or select_i) begin
	data1 = (data1_32_i & 32'hF0000000) | data1_28_i;
	case(select_i)
		1: data_o = data1;
		0: data_o = data2_i;
	endcase
end

endmodule