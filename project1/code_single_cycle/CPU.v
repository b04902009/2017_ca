module CPU(
    clk_i,
    rst_i,
    start_i
);

// Ports
input           clk_i;
input           rst_i;
input           start_i;

wire    [31:0]  inst_addr, inst;
wire    [9:0]   ctrl_sig;

reg             RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, MemRead, Branch, Jump;

MUX_Add MUX_Add(
    .data1_i    (Add_PC.data_o),
    .data2_i    (),               // from Add_address.data_o
    .select_i   (Branch),
    .Zero_i     (),               // from ALU.Zero_o
    .data_o     (MUX_Jump.data2_i)
);

MUX_Jump MUX_Jump(
    .data1_28_i (),               // from ShiftLeft26.data_o
    .data1_32_i (Add_PC.data_o),
    .data2_i    (),               // from MUX_Add.data_o
    .select_i   (Jump),
    .data_o     (PC.pc_i)
);

MUX_Write MUX_Write(
    .data1_i    (),               // from DataMemory.Readdata_o
    .data2_i    (ALU.data_o),               
    .select_i   (MemtoReg),
    .data_o     (Registers.RDdata_i)                
);

DataMemory DataMemory(
    .clk_i      (clk_i),
    .addr_i     (),               // from ALU.data_o
    .Writedata_i(Registers.RTdata_o),               
    .MemRead_i  (MemRead),
    .MemWrite_i (MemWrite),
    .Readdata_o (MUX_Write.data1_i)
);

ShiftLeft26 ShiftLeft26(
    .data_i     (inst[25:0]),
    .data_o     (MUX_Jump.data1_28_i)
);

ShiftLeft32 ShiftLeft32(
    .data_i     (Sign_Extend.data_o),
    .data_o     (Add_address.data2_in)
);

Adder Add_address(
    .data1_in   (),               // from Add_PC.data_o
    .data2_in   (),               // from ShiftLeft32.data_o
    .data_o     (MUX_Add.data2_i)
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (Add_address.data1_in)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (),                // from MUX_Jump.data_o
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);


MUX5 MUX5(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (RegDst),
    .data_o     (Registers.RDaddr_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (),                // from MUX5.data_o 
    .RDdata_i   (),                // from MUX_Write.data_o
    .RegWrite_i (RegWrite),
    .RSdata_o   (ALU.data1_i), 
    .RTdata_o   (MUX32.data1_i) 
);

Control Control(
    .Op_i       (inst[31:26]),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ctrl_signal(ctrl_sig)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (MUX32.data2_i)
);

MUX32 MUX32(
    .data1_i    (),                // from Registers.RTdata_o
    .data2_i    (),                // from Sign_Extend.data_o
    .select_i   (ALUSrc),
    .data_o     (ALU.data2_i)
);

ALU ALU(
    .data1_i    (),                // from Registers.RTdata_o
    .data2_i    (),                // from MUX32.data_o
    .ALUCtrl_i  (),                // from ALU_Control.ALUCtrl_o
    .data_o     (DataMemory.addr_i),
    .Zero_o     (MUX_Add.Zero_i)
);


ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

always @(ctrl_sig) begin
    RegDst <= ctrl_sig[7];
    ALUSrc <= ctrl_sig[6];
    MemtoReg <= ctrl_sig[5];
    RegWrite <= ctrl_sig[4];
    MemWrite <= ctrl_sig[3];
    MemRead <= ctrl_sig[2];
    Branch <= ctrl_sig[1];
    Jump <= ctrl_sig[0];
end

endmodule

