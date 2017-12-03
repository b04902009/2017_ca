module MUX_Write(
    data1_i,
    data2_i,
    MemtoReg_i,
    data_o
);

input	[31:0]	data1_i, data2_i;
input			MemtoReg_i;
output	[31:0]	data_o;

reg		[31:0]	data_o;

always @(data1_i or data2_i or MemtoReg_i) begin
	case(MemtoReg_i)
		1: data_o = data1_i;
		0: data_o = data2_i;
	endcase
end

endmodule