module MUX_Control(
    hazard_i,
    ctrl_sig_i,
    // RegDst_i,
    // ALUOp_i,
    // ALUSrc_i,
    // RegWrite_i,
    // MemRead_i,
    // MemWrite_i,
    // MemtoReg_i,
    WB_o,
    M_o,
    EX_o       
);

input               hazard_i;
// input   [1:0]       ALUOp_i;
input   [9:0]       ctrl_sig_i;
// reg     [9:0]       ctrl_sig_i;
reg                 RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, MemRead;
reg     [1:0]       ALUOp;

output  [1:0]       WB_o, M_o;
output  [3:0]       EX_o;

reg     [1:0]       WB_o, M_o;
reg     [3:0]       EX_o;

always @(hazard_i or ctrl_sig_i) begin
    if(hazard_i) begin
        WB_o <= 2'b00;
        M_o <= 2'b00;
        EX_o <= 4'b00;
    end
    else begin
        ALUOp = ctrl_sig_i[9:8];
        RegDst = ctrl_sig_i[7];
        ALUSrc = ctrl_sig_i[6];
        MemtoReg = ctrl_sig_i[5];
        RegWrite = ctrl_sig_i[4];
        MemWrite = ctrl_sig_i[3];
        MemRead = ctrl_sig_i[2];
        WB_o <= {RegWrite, MemtoReg};
        M_o <= {MemRead, MemWrite};
        EX_o <= {ALUSrc, ALUOp[1:0], RegDst};
    end
end

endmodule