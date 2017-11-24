module CPU(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire    [31:0] inst_addr, inst;

MUX_Add MUX_Add(
    .data1_i    (Add_PC.data_o),
    .data2_i    (),               // from Add_address.data_o
    .Branch_i   (),               // from Control.Branch_o
    .Zero_i     (),               // from ALU.Zero_o
    .data_o     (MUX_Jump.data2_i)
);

MUX_Jump MUX_Jump(
    .data1_28_i (),               // from ShiftLeft26.data_o
    .data1_32_i (Add_PC.data_o),
    .data2_i    (),               // from MUX_Add.data_o
    .Jump_i     (),               // from Control.Jump_o
    .data_o     (PC.pc_i)
);

MUX_Write MUX_Write(
    .data1_i    (),               // from DataMemory.Readdata_o
    .data2_i    (ALU.data_o),               
    .MemtoReg_i (Control.MemWrite_o),
    .data_o     (Registers.RDdata_i)                
);

DataMemory DataMemory(
    .addr_i     (),               // from ALU.data_o
    .Writedata_i(Registers.RTdata_o),               
    .MemRead_i  (),               // Control.MemRead_o
    .MemWrite_i (),               // Control.MemWrite_o
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
    .select_i   (),                // from Control.RegDst_o
    .data_o     (Registers.RDaddr_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (),                // from MUX5.data_o 
    .RDdata_i   (),                // from MUX_Write.data_o
    .RegWrite_i (),                // from Control.RegWrite_o
    .RSdata_o   (ALU.data1_i), 
    .RTdata_o   (MUX32.data1_i) 
);

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (MUX5.select_i),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX32.select_i),
    .RegWrite_o (Registers.RegWrite_i),
    .Jump_o     (MUX_Jump.Jump_i),
    .Branch_o   (MUX_Add.Branch_i),
    .MemRead_o  (DataMemory.MemRead_i),
    .MemWrite_o (DataMemory.MemWrite_i),
    .MemtoReg_o (MUX_Write.MemtoReg_i)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (MUX32.data2_i)
);

MUX32 MUX32(
    .data1_i    (),                // from Registers.RTdata_o
    .data2_i    (),                // from Sign_Extend.data_o
    .select_i   (),                // from Control.ALUSrc_o
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
    .ALUOp_i    (),                // from Control.ALUOp_o
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

endmodule

