module CLA_5_5_6_adder
(
input [15:0] A, B,
input cin,
output [15:0] R

);

wire c1, c2;

carry_look_ahead_adder_cin_cout_5 CLA1(.A(A[4:0]) , .B(B[4:0]) , .cin(cin) , .cout(c1) , .R(R[4:0]));

carry_look_ahead_adder_cin_cout_5 CLA2(.A(A[9:5]) , .B(B[9:5]) , .cin(c1) , .cout(c2) , .R(R[9:5]));

carry_look_ahead_adder_cin_cout_6 CLA3(.A(A[15:10]) , .B(B[15:10]) , .cin(c2) , .cout(0) , .R(R[15:10]));





endmodule