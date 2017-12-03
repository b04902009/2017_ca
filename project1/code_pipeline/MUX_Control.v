module MUX_Control(
    hazard_i,
    RegDst_i,
    ALUOp_i,
    ALUSrc_i,
    RegWrite_i,
    MemRead_i,
    MemWrite_i,
    MemtoReg_i,
    WB_o,
    M_o,
    EX_o       
);

input               hazard_i;
input               RegDst_i, ALUSrc_i, MemtoReg_i, RegWrite_i, MemWrite_i, MemRead_i;
input   [1:0]       ALUOp_i;
output  [1:0]       WB_o, M_o;
output  [3:0]       EX_o;

reg     [1:0]       WB_o, M_o;
reg     [3:0]       EX_o;

always @(hazard_i or RegDst_i or ALUSrc_i or MemtoReg_i or RegWrite_i or MemWrite_i or MemRead_i or ALUOp_i) begin
    if(hazard_i) begin
        WB_o <= 2'b00;
        M_o <= 2'b00;
        EX_o <= 4'b00;
    end
    else begin
        WB_o <= {RegWrite_i, MemtoReg_i};
        M_o <= {MemRead_i, MemWrite_i};
        EX_o <= {ALUSrc_i, ALUOp_i[1:0], RegDst_i};
    end
end

endmodule