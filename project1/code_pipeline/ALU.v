module ALU(
	data1_i,
	data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input	[31:0]		data1_i, data2_i;
input	[2:0]		ALUCtrl_i;
output	[31:0]		data_o;
output				Zero_o;

// ALUCtrl:   000:and, 001:or, 010:add, 110:sub, 101:mul
assign	data_o = (ALUCtrl_i == 3'b000)?	data1_i & data2_i :
				 (ALUCtrl_i == 3'b001)?	data1_i | data2_i :
				 (ALUCtrl_i == 3'b010)?	data1_i + data2_i :
				 (ALUCtrl_i == 3'b110)?	data1_i - data2_i :
				 (ALUCtrl_i == 3'b101)?	data1_i * data2_i :
				 32'd0;

assign	Zero_o = (data1_i == data2_i)?	1'b1 : 1'b0;
endmodule