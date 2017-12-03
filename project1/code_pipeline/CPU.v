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
wire            Zero;


IFID IFID(
    .clk_i      (clk_i),
    .pc_i       (),               // from Add_PC.data_o
    .hazard_i   (),               // from HazardDetection.IDIFhazard_o
    .flush_i    (),               // from Flush.flush_o
    .inst_i     (),               // from Instruction_Memory.instr_o
    .inst_o     (inst),
    .pc_o       (Add_address.data1_in)
);

IDEX IDEX(
    .clk_i      (clk_i),
    .WB_i       (),               //
    .M_i        (),               // from MUX_Control
    .EX_i       (),               // 
    .data1_i    (),               // from Registers.RSdata_o
    .data2_i    (),               // from Registers.RTdata_o
    .signextend_i(Sign_Extend.data_o),
    .rs_i       (inst[25:21]),
    .rt_i       (inst[20:16]),
    .rd_i       (inst[15:11]),
    .WB_o       (EXMEM.WB_i),
    .M_o        (EXMEM.M_i),
    .ALUSrc_o   (MUX32_2.select_i),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .RegDst_o   (MUX5.select_i),
    .data1_o    (MUXforward_1.data_i),
    .data2_o    (MUXforward_2.data_i),
    .signextend_o(MUX32_2.data2_i),
    .rs_o       (ForwardUnit.IDEX_RS_i),
    .rt_o       (MUX5.data1_i),
    .rd_o       (MUX5.data2_i)
);

EXMEM EXMEM(
    .clk_i      (clk_i),
    .WB_i       (),                // from IDEX.WB_o  
    .M_i        (),                // from IDEX.M_o
    .addr_i     (),                // from ALU.data_o
    .data_i     (),                // MUXforward_2.data_o
    .rd_i       (),                // from MUX5.data_o
    .WB_o       (MEMWB.WB_i),
    .MemRead_o  (DataMemory.MemRead_i),
    .MemWrite_o (DataMemory.MemWrite_i),
    .addr_o     (DataMemory.addr_i),
    .data_o     (DataMemory.Writedata_i),
    .rd_o       (MEMWB.rd_i)
);

MEMWB MEMWB(
    .clk_i      (clk_i),
    .WB_i       (),                // from EXMEM.WB_o
    .addr_i     (),                // from EXMEM.addr_o
    .data_i     (),                // from EXMEM.data_o
    .rd_i       (),                // from EXMEM.rd_o
    .MemtoReg_o (MUX_Write.select_i),
    .RegWrite_o (Registers.RegWrite_i),
    .addr_o     (MUX_Write.data1_i),
    .data_o     (MUX_Write.data2_i),
    .rd_o       (Registers.RDaddr_i)
);

ForwardUnit ForwardUnit(
    .IDEX_RS_i  (IDEX.rs_o),
    .IDEX_RT_i  (IDEX.rt_o),
    .EXMEM_RegWrite_i(EXMEM.WB_o[1]),
    .EXMEM_RD_i (EXMEM.rd_o),
    .MEMWB_RegWrite_i(MEMWB.RegWrite_o),
    .MEMWB_RD_i (MEMWB.rd_o),
    .Forward1_o (MUXforward_1.select_i),
    .Forward2_o (MUXforward_2.select_i)
);

MUXForward MUXforward_1(
    .select_i   (),              // from ForwardUnit.Forward1_o
    .data_i     (),              // from IDEX.data1_o
    .EXMEM_addr_i(EXMEM.addr_o),
    .MEMWB_data_i(MUX_Write.data_o),
    .data_o     (ALU.data1_i)
);

MUXForward MUXforward_2(
    .select_i   (),              // from ForwardUnit.Forward2_o
    .data_i     (),              // from IDEX.data2_o
    .EXMEM_addr_i(EXMEM.addr_o),
    .MEMWB_data_i(MUX_Write.data_o),
    .data_o     (EXMEM.data_i)
);

HazardDetection HazardDetection(
    .inst_i     (inst), 
    .rt_i       (IDEX.rt_o), 
    .MemRead_i  (IDEX.M_o[1]), 
    .hazard_o   (PC.hazard_i), 
    .IFIDhazard_o(IFID.hazard_i), 
    .MUX_Control_hazard_o(MUX_Control.hazard_i)
);

MUX_Add MUX_Add(
    .data1_i    (Add_PC.data_o),
    .data2_i    (),               // from Add_address.data_o
    .select_i   (Branch),
    .Zero_i     (Zero),
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
    .data1_i    (),                // from MEMWB.addr_o
    .data2_i    (),                // from MEMWB.data_o               
    .select_i   (),                // from MEMWB.MemtoReg_o
    .data_o     (Registers.RDdata_i)                
);

DataMemory DataMemory(
    .clk_i      (clk_i),
    .addr_i     (),               // from EXMEM.addr_o
    .Writedata_i(),               // from EXMEM.data_o               
    .MemRead_i  (),               // from EXMEM.MemRead_o
    .MemWrite_i (),               // from EXMEM.MemWrite_o
    .Readdata_o (MEMWB.data_i)
);

ShiftLeft26 ShiftLeft26(
    .data_i     (inst[25:0]),
    .data_o     (MUX_Jump.data1_28_i)
);

ShiftLeft32 ShiftLeft32(
    .data_i     (),               // from Sign_Extend.data_o
    .data_o     (Add_address.data2_in)
);

Adder Add_address(
    .data1_in   (),               // from IFID.pc_o
    .data2_in   (),               // from ShiftLeft32.data_o
    .data_o     (MUX_Add.data2_i)
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (IFID.pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .hazard_i   (),                // from HazardDetection.hazard_o
    .pc_i       (),                // from MUX_Jump.data_o
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (IFID.inst_i)
);


MUX5 MUX5(
    .data1_i    (),                // from IDEX.rt_o
    .data2_i    (),                // from IDEX.rd_o
    .select_i   (),                // from IDEX.RegDst_o
    .data_o     (EXMEM.rd_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (),                // from MEMWB.rd_o 
    .RDdata_i   (),                // from MUX_Write.data_o
    .RegWrite_i (),                // from MEMWB.RegWrite_o
    .RSdata_o   (IDEX.data1_i), 
    .RTdata_o   (IDEX.data2_i) 
);

MUX_Control MUX_Control(
    .hazard_i   (),                // from HazardDetection.MUX_Control_hazard_o
    .RegDst_i   (RegDst),
    .ALUOp_i    (),                // from Control.ALUOp_o
    .ALUSrc_i   (ALUSrc),
    .RegWrite_i (RegWrite),
    .MemRead_i  (MemRead),
    .MemWrite_i (MemWrite),
    .MemtoReg_i (MemtoReg),
    .WB_o       (IDEX.WB_i),
    .M_o        (IDEX.M_i),
    .EX_o       (IDEX.EX_i)
);

Control Control(
    .Op_i       (inst[31:26]),
    .ALUOp_o    (MUX_Control.ALUOp_i),
    .ctrl_signal(ctrl_sig)
);

Flush Flush(
    .Jump_i     (Jump),
    .Branch_i   (Branch),
    .Zero_i     (Zero),
    .flush_o    (IFID.flush_i)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (ShiftLeft32.data_i)
);

MUX32 MUX32_2(
    .data1_i    (),                // from MUXForward2.data_o
    .data2_i    (),                // from IDEX.signextend_o
    .select_i   (),                // from IDEX.ALUSrc_o
    .data_o     (ALU.data2_i)
);

ALU ALU(
    .data1_i    (),                // from Registers.RTdata_o
    .data2_i    (),                // from MUX32.data_o
    .ALUCtrl_i  (),                // from ALU_Control.ALUCtrl_o
    .data_o     (EXMEM.addr_i),
    .Zero_o     (Zero)
);


ALU_Control ALU_Control(
    .funct_i    (IDEX.signextend_o[5:0]),
    .ALUOp_i    (),                // from IDEX.ALUOP_o              
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
