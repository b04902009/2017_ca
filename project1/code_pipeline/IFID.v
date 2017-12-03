module IFID(
    clk_i,
    pc_i,
    hazard_i,
    flush_i,
    inst_i,
    inst_o,
    pc_o
);

input				clk_i, hazard_i, flush_i;
input	[31:0]		pc_i, inst_i;
output	[31:0]		pc_o, inst_o;

reg 	[31:0]		pc_o, inst_o;

initial begin
#5
	pc_o = 0;
	inst_o = 0;
end

always@(posedge clk_i) begin
	if (flush_i) begin
		pc_o <= 0;
		inst_o <= 0;
	end
	else if(hazard_i) begin
		pc_o <= pc_i;
		inst_o <= inst_i;
	end
end

endmodule