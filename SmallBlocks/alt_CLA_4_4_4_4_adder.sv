module alt_CLA_4_4_4_4_adder
(
input [15:0] A, B,
input cin,
output [15:0] R

);

wire c1, c2, c3;

alt_carry_look_ahead_adder_cin_4 CLA1(.A(A[3:0]) , .B(B[3:0]) , .cin(cin) , .cout(c1) , .R(R[3:0]));

alt_carry_look_ahead_adder_cin_4 CLA2(.A(A[7:4]) , .B(B[7:4]) , .cin(c1) , .cout(c2) , .R(R[7:4]));

alt_carry_look_ahead_adder_cin_4 CLA3(.A(A[11:8]) , .B(B[11:8]) , .cin(c2) , .cout(c3) , .R(R[11:8]));

alt_carry_look_ahead_adder_cin_4 CLA4(.A(A[15:12]) , .B(B[15:12]) , .cin(c3) , .cout(0) , .R(R[15:12]));




endmodule