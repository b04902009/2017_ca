module HazardDetection(
    inst_i, 
    rt_i, 
    MemRead_i, 
    hazard_o, 
    IFIDhazard_o, 
    MUX_Control_hazard_o
);

input				MemRead_i;
input	[4:0]		rt_i;
input	[31:0]		inst_i;
output				hazard_o, IFIDhazard_o, MUX_Control_hazard_o;
wire				hazard_o;

assign	hazard_o = ((inst_i[25:21] == rt_i)|(inst_i[20:16] == rt_i))? MemRead_i : 1'b0;
assign	IFIDhazard_o = hazard_o;
assign	MUX_Control_hazard_o = hazard_o;

endmodule