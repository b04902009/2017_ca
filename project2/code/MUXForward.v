module MUXForward(
    select_i,
    data_i,
    EXMEM_addr_i,
    MEMWB_data_i,
    data_o
);

input	[1:0]		select_i;
input	[31:0]		data_i, EXMEM_addr_i, MEMWB_data_i;
output	[31:0]		data_o;
reg 	[31:0]		data_o;

always @(select_i or data_i or EXMEM_addr_i or MEMWB_data_i) begin
	case(select_i)
		2'b10: assign data_o = EXMEM_addr_i;
		2'b01: assign data_o = MEMWB_data_i;
		2'b00: assign data_o = data_i;
	endcase
end

endmodule