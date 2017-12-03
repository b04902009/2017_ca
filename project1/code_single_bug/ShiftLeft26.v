module ShiftLeft26(
	data_i,
	data_o
);

input	[25:0]	data_i;
output	[27:0]	data_o;

reg		[27:0]  data_o;

always @(data_i) begin
	data_o = data_i | 28'h0;
	data_o = data_o << 2;
end

endmodule