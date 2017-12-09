module Control(
    Op_i,
    ctrl_signal_o,
    branch_o,
    jump_o
);

input	[5:0]		Op_i;
output	reg			branch_o, jump_o;
output	[9:0]		ctrl_signal_o;
reg		[9:0]		ctrl_signal_o;

always @(*) begin
	branch_o = 1'd0;
	jump_o = 1'd0;
	case(Op_i)
		6'h00: // R-type
			ctrl_signal_o <= {2'b11, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
		6'h08: // addi
			ctrl_signal_o <= {2'b00, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
		6'h23: // lw
			ctrl_signal_o <= {2'b00, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0};
		6'h2B: // sw
			ctrl_signal_o <= {2'b00, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
		6'h04: // beq
			begin
			ctrl_signal_o <= {2'b01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
			branch_o = 1'd1;
			end
		6'h0D:  //ori
			ctrl_signal_o <= {2'b10, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
		6'h02: // jump
			begin
			ctrl_signal_o <= {2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
			jump_o = 1'd1;
			end
		default:
		 	ctrl_signal_o <= 10'd0;
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

always@(*) begin
	$display("Control-Op_i: %b", Op_i);
end
endmodule
