module alt_two_CLA8_adders
(

input [15:0] A, B,
input cin,
output [15:0] R
);
wire c1;
alt_carry_look_ahead_adder_cin_8 CLA1(.A(A[7:0]) , .B(B[7:0]) , .R(R[7:0]) , .cin(cin) , .cout(c1));
alt_carry_look_ahead_adder_cin_8 CLA2(.A(A[15:8]) , .B(B[15:8]) , .R(R[15:8]) , .cin(c1) , .cout(0));
endmodule
