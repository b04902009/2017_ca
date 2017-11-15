module Control(
    Op_i,
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

input	[5:0]		Op_i;
output	[1:0]		ALUOp_o;
output 				RegDst_o, ALUSrc_o, RegWrite_o;
reg		[4:0]		ctrl_signal;

always @(Op_i) begin
	case(Op_i)
		6'h00: // R-type
			ctrl_signal <= {2'b11, 1'b1, 1'b0, 1'b1};
		6'h08: // addi
			ctrl_signal <= {2'b00, 1'b0, 1'b1, 1'b1};
		default:
		 	ctrl_signal <= 5'd0;
	endcase
end

assign	ALUOp_o = ctrl_signal[4:3];
assign	RegDst_o = ctrl_signal[2];
assign	ALUSrc_o = ctrl_signal[1];
assign	RegWrite_o = ctrl_signal[0];


/*
Instruction	Opcode			ALUOp		RegDst	ALUSrc	RegWrite
R-type		000000(0x00)	11(Rtype)	1		0		1
[I-type]
addi		001000(0x08)	00(add)		0		1		1
lw			100011(0x23)	00(add)		0		1		1
sw			101011(0x2B)	00(add)		x		1		0
beq			000100(0x04)	01(sub)		x		0		0
ori			001101(0x0D)	10(or)		0		1		1
jump		000010(0x02)	X			x		x		0
*/
endmodule