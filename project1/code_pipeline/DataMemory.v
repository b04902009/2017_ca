module DataMemory(
	clk_i,
    addr_i,
    Writedata_i,
    MemRead_i,
    MemWrite_i,
    Readdata_o
);

input	[31:0]		addr_i, Writedata_i;
input				clk_i, MemRead_i, MemWrite_i;
output	[31:0]		Readdata_o;
reg		[7:0]		memory 	[0:31];
reg		[31:0]		Readdata_o;

always @(posedge clk_i) begin
	if (MemWrite_i) begin
		memory[addr_i] = Writedata_i[7:0];
		memory[addr_i+1] = Writedata_i[15:8];
		memory[addr_i+2] = Writedata_i[23:16];
		memory[addr_i+3] = Writedata_i[31:24];
		$display("In Write: %b", memory[addr_i]);
	end
end

always @(MemRead_i) begin
	if (MemRead_i) begin
		Readdata_o = {memory[addr_i+3], memory[addr_i+2], memory[addr_i+1], memory[addr_i]};
		$display("In Read: %b", Readdata_o);		
	end
end

endmodule