module adder_to_use_16_bit
(

input [15:0] A, B,
output [15:0] R,
input cin

);


alt_carry_look_ahead_adder_cin Adder(.A(A) , .B(B) , .cin(cin) , .R(R));


endmodule