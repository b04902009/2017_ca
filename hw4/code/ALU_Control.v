module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input	[5:0]		funct_i;
input	[1:0]		ALUOp_i;
output	[2:0]		ALUCtrl_o;


assign	ALUCtrl_o = (ALUOp_i == 2'b00)?						3'b010 :	// addi
					(ALUOp_i == 2'b11 && funct_i == 6'h20)?	3'b010 :	// add
					(ALUOp_i == 2'b11 && funct_i == 6'h22)?	3'b110 :	// sub
					(ALUOp_i == 2'b11 && funct_i == 6'h24)?	3'b000 :	// and
					(ALUOp_i == 2'b11 && funct_i == 6'h25)?	3'b001 :	// or
					(ALUOp_i == 2'b11 && funct_i == 6'h18)?	3'b101 :	// mul
					3'b000;

/*
R-type (Opcode=0x00, ALUOp=11)
Instruction	Opcode			ALUOp		Func_code		ALU_ctrl
add			000000(0x00)	11(Rtype)	100000(0x20)	010
sub			000000(0x00)	11(Rtype)	100010(0x22)	110
and			000000(0x00)	11(Rtype)	100100(0x24)	000
or			000000(0x00)	11(Rtype)	100101(0x25)	001
mul			000000(0x00)	11(Rtype)	011000(0x18)	101(Self_defined)

I-type (no Func_code)
Instruction	Opcode			ALUOp		Func_code		ALU_ctrl
addi		001000(0x08)	00(add)		X				010
lw			100011(0x23)	00(add)		X				010
sw			101011(0x2B)	00(add)		X				010
beq			000100(0x04)	01(sub)		X				110
ori			001101(0x0D)	10(or)		X				001
jump		000010(0x02)	X			X				X

Reference: 	https://en.wikibooks.org/wiki/MIPS_Assembly/Instruction_Formats
*/

endmodule