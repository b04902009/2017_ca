module DataMemory(
    addr_i,
    Writedata_i,
    MemRead_i,
    MemWrite_i,
    Readdata_o
);

input	[31:0]	addr_i, Writedata_i;
input			MemRead_i, MemWrite_i;
output	[31:0]	Readdata_o;

reg		[7:0]	memory 	[0:31];
reg		[31:0]	Readdata_o;

always @(addr_i or Writedata_i or MemRead_i or MemWrite_i) begin
	if (MemRead_i) begin
		Readdata_o <= {memory[addr_i+3], memory[addr_i+2], memory[addr_i+1], memory[addr_i]};
		//Readdata_o[7:0] <= memory[addr_i];
		//Readdata_o[15:8] <= memory[addr_i+1];
		//Readdata_o[23:16] <= memory[addr_i+2];
		//Readdata_o[31:24] <= memory[addr_i+3];		
	end
	if (MemWrite_i) begin
		memory[addr_i] = Writedata_i[7:0];
		memory[addr_i+1] = Writedata_i[15:8];
		memory[addr_i+2] = Writedata_i[23:16];
		memory[addr_i+3] = Writedata_i[31:24];
		//$display("%b", Writedata_i[7:0]);
	end
	
	$display("DataMemory-MemWrite: %b", MemWrite_i);
	$display("DataMemory-MemRead: %b", MemRead_i);
	$display("Writedata:%b", Writedata_i[7:0]);
	
end

endmodule