module MUX_Add(
    data1_i,
    data2_i,
    Branch_i,
    Zero_i,
    data_o
);

input	[31:0]	data1_i, data2_i;
input			Branch_i, Zero_i;
output	[31:0]	data_o;
reg		[31:0]	data_o;

reg		select;

always @(data1_i or data2_i or Branch_i or Zero_i) begin
	select = (Branch_i == 1 && Zero_i == 1)? 1:0;
	case(select)
		1: data_o = data2_i;
		0: data_o = data1_i;
	endcase
end

endmodule