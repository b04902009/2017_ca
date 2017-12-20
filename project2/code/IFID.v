module IFID(
    clk_i,
    rst_i,
    pc_i,
    hazard_i,
    flush_i,
    inst_i,
    halt_i,
    inst_o,
    pc_o
);

input				clk_i, rst_i, hazard_i, flush_i, halt_i;
input	[31:0]		pc_i, inst_i;
output	[31:0]		pc_o, inst_o;

reg 	[31:0]		pc_o, inst_o;


always@(posedge clk_i or negedge rst_i) begin
	if(halt_i) begin
	end
	else if(~rst_i) begin
		pc_o = 32'b0;
		inst_o = 32'b0;
	end
	else if(flush_i) begin
		pc_o <= 32'b0;
		inst_o <= 32'b0;
	end
	else if(!hazard_i) begin
		pc_o <= pc_i;
		inst_o <= inst_i;
	end
end

endmodule