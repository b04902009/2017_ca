module Flush(
    Jump_i,
    Branch_i,
    Zero_i,
    flush_o
);

input				Jump_i, Branch_i, Zero_i;
output				flush_o;

assign flush_o = (Zero_i & Branch_i) | Jump_i;

endmodule


// Check 
// Note : (Zero_i & Branch_i) Do at here is not quite good
