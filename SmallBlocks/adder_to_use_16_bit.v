module adder_to_use_16_bit
(

input [15:0] A, B,
output [15:0] R,
input cin

);


Simple16add Adder(.A(A) , .B(B) , .cin(cin) , .R(R));


endmodule