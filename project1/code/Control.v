module Control(
    Op_i,
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    Jump_o,
    Branch_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o
);

input	[5:0]		Op_i;
output	[1:0]		ALUOp_o;
output 				RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, MemRead_o, Branch_o, Jump_o;
reg		[9:0]		ctrl_signal;

always @(Op_i) begin
	case(Op_i)
		6'h00: // R-type
			ctrl_signal <= {2'b11, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
		6'h08: // addi
			ctrl_signal <= {2'b00, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
		6'h23: // lw
			ctrl_signal <= {2'b00, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0};
		6'h2B: // sw
			ctrl_signal <= {2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
		6'h04: // beq
			ctrl_signal <= {2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
		6'h0D:  //ori
			ctrl_signal <= {2'b10, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
		6'h02: // jump
			ctrl_signal <= {2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
		default:
		 	ctrl_signal <= 5'd0;
	endcase
end

/*
Instruction	Opcode			ALUOp		RegDst	ALUSrc	MemtoReg	RegWrite	MemWrite	MemRead	Branch	Jump
R-type		000000(0x00)	11(Rtype)	1		0		0			1			0			0		0		0
[I-type]
addi		001000(0x08)	00(add)		0		1		0			1			0			0		0		0	
lw			100011(0x23)	00(add)		0		1		1			1			0			1		0		0
sw			101011(0x2B)	00(add)		x		1		x			0			1			0		0		0
beq			000100(0x04)	01(sub)		x		0		x			0			0			0		1		0
ori			001101(0x0D)	10(or)		0		1		0			1			0			0		0		0
jump		000010(0x02)	X			x		x		x			0			0			0		0		1
*/

assign	ALUOp_o = ctrl_signal[9:8];
assign	RegDst_o = ctrl_signal[7];
assign	ALUSrc_o = ctrl_signal[6];
assign	MemtoReg_o = ctrl_signal[5];
assign	RegWrite_o = ctrl_signal[4];
assign	MemWrite_o = ctrl_signal[3];
assign	MemtoReg_o = ctrl_signal[2];
assign	Branch_o = ctrl_signal[1];
assign	Jump_o = ctrl_signal[0];

endmodule