module CPU(
    clk_i,
    rst_i,
    start_i,
    mem_data_i, 
    mem_ack_i,  
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire    [31:0]      inst_addr, inst;
wire                Zero;
wire                Branch, Jump;
wire    [31:0]      MUXforward2_data;

// Data Memory interface
input   [256-1:0]   mem_data_i;
input               mem_ack_i; 
output  [256-1:0]   mem_data_o;
output  [32-1:0]    mem_addr_o;    
output              mem_enable_o;
output              mem_write_o;

//data cache
dcache_top dcache(
    // System clock, reset and stall
    .clk_i(clk_i), 
    .rst_i(rst_i),
    
    // to Data Memory interface     
    .mem_data_i(mem_data_i), 
    .mem_ack_i(mem_ack_i),  
    .mem_data_o(mem_data_o), 
    .mem_addr_o(mem_addr_o),    
    .mem_enable_o(mem_enable_o), 
    .mem_write_o(mem_write_o), 
    
    // to CPU interface 
    .p1_data_i(), 
    .p1_addr_i(),   
    .p1_MemRead_i(), 
    .p1_MemWrite_i(), 
    .p1_data_o(), 
    .p1_stall_o()
);


IFID IFID(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .pc_i       (),               // from Add_PC.data_o
    .hazard_i   (),               // from HazardDetection.IDIFhazard_o
    .flush_i    (),               // from Flush.flush_o
    .inst_i     (),               // from Instruction_Memory.instr_o
    .inst_o     (inst),
    .pc_o       (Add_address.data1_in)
);

IDEX IDEX(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .WB_i       (),               // from MUX_Control.WB_o
    .M_i        (),               // from MUX_Control.M_o
    .EX_i       (),               // from MUX_Control.EX_o
    .data1_i    (),               // from Registers.RSdata_o
    .data2_i    (),               // from Registers.RTdata_o
    .signextend_i(Sign_Extend.data_o),
    .rs_i       (inst[25:21]),
    .rt_i       (inst[20:16]),
    .rd_i       (inst[15:11]),
    .WB_o       (EXMEM.WB_i),
    .M_o        (EXMEM.M_i),
    .EX_o       (),
    .data1_o    (MUXforward_1.data_i),
    .data2_o    (MUXforward_2.data_i),
    .signextend_o(MUX32.data2_i),
    .rs_o       (ForwardUnit.IDEX_RS_i),
    .rt_o       (MUX5.data1_i),
    .rd_o       (MUX5.data2_i)
);

EXMEM EXMEM(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .WB_i       (),                // from IDEX.WB_o  
    .M_i        (),                // from IDEX.M_o
    .addr_i     (),                // from ALU.data_o
    .data_i     (MUXforward2_data),
    .rd_i       (),                // from MUX5.data_o
    .WB_o       (MEMWB.WB_i),
    .M_o        (),
    .addr_o     (DataMemory.addr_i),
    .data_o     (DataMemory.Writedata_i),
    .rd_o       (MEMWB.rd_i)
);

MEMWB MEMWB(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .WB_i       (),                // from EXMEM.WB_o
    .addr_i     (EXMEM.addr_o),    // from EXMEM.addr_o
    .data_i     (),                // from DataMemory.Readdata_o
    .rd_i       (),                // from EXMEM.rd_o
    .WB_o       (),
    .addr_o     (MUX_Write.data2_i), // here makes mistake ..
    .data_o     (MUX_Write.data1_i),
    .rd_o       (Registers.RDaddr_i)
);

ForwardUnit ForwardUnit(
    .IDEX_RS_i  (),                 // from IDEX.rs_o
    .IDEX_RT_i  (IDEX.rt_o),
    .EXMEM_RegWrite_i(EXMEM.WB_o[1]),
    .EXMEM_RD_i (EXMEM.rd_o),
    .MEMWB_RegWrite_i(MEMWB.WB_o[1]),
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
    .data_o     (MUXforward2_data)
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
    .data1_32_i (MUX_Add.data_o),
    .data2_i    (),               // from MUX_Add.data_o
    .select_i   (Jump),
    .data_o     (PC.pc_i)
);

MUX_Write MUX_Write(
    .data1_i    (),                // from MEMWB.addr_o
    .data2_i    (),                // from MEMWB.data_o               
    .select_i   (MEMWB.WB_o[0]),
    .data_o     (Registers.RDdata_i)                
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
    .clk_i(clk_i),
    .rst_i(rst_i),
    .start_i(start_i),
    .stall_i(),                     // from HazardDetection.hazard_o
    .pcEnable_i(),
    .pc_i(),                        // from MUX_Jump.data_o
    .pc_o(inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (IFID.inst_i)
);

MUX5 MUX5(
    .data1_i    (),                // from IDEX.rt_o
    .data2_i    (),                // from IDEX.rd_o
    .select_i   (IDEX.EX_o[0]),     // IDEX_RegDst
    .data_o     (EXMEM.rd_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (),                // from MEMWB.rd_o 
    .RDdata_i   (),                // from MUX_Write.data_o
    .RegWrite_i (MEMWB.WB_o[1]),
    .RSdata_o   (IDEX.data1_i), 
    .RTdata_o   (IDEX.data2_i) 
);

assign Zero = (Registers.RSdata_o == Registers.RTdata_o) ? 1'b1 : 1'b0;

MUX_Control MUX_Control(
    .hazard_i   (),                // from HazardDetection.MUX_Control_hazard_o
    .ctrl_sig_i (),                // from Control.ctrl_signal
    .WB_o       (IDEX.WB_i),
    .M_o        (IDEX.M_i),
    .EX_o       (IDEX.EX_i)
);

Control Control(
    .Op_i       (inst[31:26]),
    .ctrl_signal_o(MUX_Control.ctrl_sig_i),
    .branch_o   (Branch),
    .jump_o     (Jump)
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

MUX32 MUX32(
    .data1_i    (MUXforward2_data),
    .data2_i    (),                // from IDEX.signextend_o
    .select_i   (IDEX.EX_o[3]),     // IDEX_ALUSrc
    .data_o     (ALU.data2_i)
);

ALU ALU(
    .data1_i    (),                // from MUXforward_1.data_o
    .data2_i    (),                // from MUX32.data_o
    .ALUCtrl_i  (),                // from ALU_Control.ALUCtrl_o
    .data_o     (EXMEM.addr_i)
);

ALU_Control ALU_Control(
    .funct_i    (IDEX.signextend_o[5:0]),
    .ALUOp_i    (IDEX.EX_o[2:1]),      // IDEX_ALUOp
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

endmodule
