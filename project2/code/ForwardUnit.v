module ForwardUnit(
    IDEX_RS_i,
    IDEX_RT_i,
    EXMEM_RegWrite_i,
    EXMEM_RD_i,
    MEMWB_RegWrite_i,
    MEMWB_RD_i,
    Forward1_o,
    Forward2_o
);

input				EXMEM_RegWrite_i, MEMWB_RegWrite_i;
input	[4:0]		IDEX_RS_i, IDEX_RT_i, EXMEM_RD_i, MEMWB_RD_i;
output	[1:0]		Forward1_o, Forward2_o;

reg 	[1:0]		Forward1_o, Forward2_o;



always @(EXMEM_RegWrite_i or MEMWB_RegWrite_i or IDEX_RS_i or IDEX_RT_i or EXMEM_RD_i or MEMWB_RD_i) begin
	Forward1_o = 2'b00;
	if(EXMEM_RegWrite_i && (EXMEM_RD_i != 5'd0) && (EXMEM_RD_i == IDEX_RS_i))
		Forward1_o = 2'b10;
	/* hortune
    else if(MEMWB_RegWrite_i && (MEMWB_RD_i != 5'd0) && (MEMWB_RD_i == IDEX_RS_i) && (EXMEM_RD_i != IDEX_RS_i))
		Forward1_o = 2'b01;
	*/
    else if(MEMWB_RegWrite_i && (MEMWB_RD_i != 5'd0) && (MEMWB_RD_i == IDEX_RS_i))
		Forward1_o = 2'b01;
	Forward2_o = 2'b00;
	
    if (EXMEM_RegWrite_i && (EXMEM_RD_i != 5'd0) && (EXMEM_RD_i == IDEX_RT_i))
		Forward2_o = 2'b10;
	/* hortune
    else if (MEMWB_RegWrite_i && (MEMWB_RD_i != 5'd0) && (MEMWB_RD_i == IDEX_RT_i) && (EXMEM_RD_i != IDEX_RT_i))
		Forward2_o = 2'b01;
    */
    else if (MEMWB_RegWrite_i && (MEMWB_RD_i != 5'd0) && (MEMWB_RD_i == IDEX_RT_i))
		Forward2_o = 2'b01;

end



endmodule
