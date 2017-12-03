module ShiftLeft32(
	data_i,
	data_o
);

input	[31:0]	data_i;
output	[31:0]	data_o;

reg		[31:0]  data_o;

always @(data_i) begin
	data_o = data_o << 2;
end

endmodule