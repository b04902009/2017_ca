module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;


wire    [31:0]      instr;
wire    [1:0]       ALUOp;
wire                RegDst, ALUSrc, RegWrite;
Control Control(
    .Op_i       (instr[31:26]),
    .RegDst_o   (RegDst),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite)
);


wire    [31:0]      instr_addr, next_instr_addr;
Adder Add_PC(
    .data1_in   (instr_addr),
    .data2_in   (32'd4),
    .data_o     (next_instr_addr)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (next_instr_addr),
    .pc_o       (instr_addr)
);


Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr), 
    .instr_o    (instr)
);


wire     [31:0]      RSdata, RTdata;
Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (instr[25:21]),
    .RTaddr_i   (instr[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o), 
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (RegWrite), 
    .RSdata_o   (RSdata), 
    .RTdata_o   (RTdata) 
);


MUX5 MUX_RegDst(
    .data1_i    (instr[20:16]),
    .data2_i    (instr[15:11]),
    .select_i   (RegDst),
    .data_o     (Registers.RDaddr_i)
);


wire    [31:0]      MUX_ALUSrc_o;
MUX32 MUX_ALUSrc(
    .data1_i    (RTdata),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (ALUSrc),
    .data_o     (MUX_ALUSrc_o)
);



Sign_Extend Sign_Extend(
    .data_i     (instr[15:0]),
    .data_o     (MUX_ALUSrc.data2_i)
);

  

ALU ALU(
    .data1_i    (RSdata),
    .data2_i    (MUX_ALUSrc_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (Registers.RDdata_i),
    .Zero_o     ()
);



ALU_Control ALU_Control(
    .funct_i    (instr[5:0]),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


endmodule