module PC(
    clk_i,
    rst_i,
    start_i,
    pc_i,
    hazard_i,
    pc_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input               hazard_i;   // hazard_i=1 : stall
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;

initial begin 
    pc_o = 0;
end

always@(posedge clk_i or negedge rst_i) begin
    // $display("hazard: %b", hazard_i);
    if(~rst_i) begin
        pc_o <= 32'b0;
    end
    else begin
        if(start_i & (!hazard_i))
            pc_o <= pc_i;
        //else
        //    pc_o <= pc_o;
    end
end

endmodule 


// MODIFY BY HORTUNE
// ADD INITIALIZATION
