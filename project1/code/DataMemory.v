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

reg		[31:0]	Readdata_o;

endmodule