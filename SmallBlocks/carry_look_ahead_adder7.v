module carry_look_ahead_adder7
(
input [6:0] A, B,
input cin,
output [6:0] R
);
wire p0,  p1,  p2,  p3,  p4,  p5,  p6; 
wire g0,  g1,  g2,  g3,  g4,  g5,  g6; 
wire c0,  c1,  c2,  c3,  c4,  c5,  c6; 

assign p0 = A[0] ^ B[0];
assign p1 = A[1] ^ B[1];
assign p2 = A[2] ^ B[2];
assign p3 = A[3] ^ B[3];
assign p4 = A[4] ^ B[4];
assign p5 = A[5] ^ B[5];
assign p6 = A[6] ^ B[6];

assign g0 = A[0] & B[0];
assign g1 = A[1] & B[1];
assign g2 = A[2] & B[2];
assign g3 = A[3] & B[3];
assign g4 = A[4] & B[4];
assign g5 = A[5] & B[5];
assign g6 = A[6] & B[6];

assign c0 = cin;
assign c1 = g0 | (p0 & cin);
assign c2 = g1 | (p1 & g0) | (p1 & p0 & cin);
assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & cin);
assign c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & cin);
assign c5 = g4 | (p4 & g3) | (p4 & p3 & g2) | (p4 & p3 & p2 & g1) | (p4 & p3 & p2 & p1 & g0) | (p4 & p3 & p2 & p1 & p0 & cin);
assign c6 = g5 | (p5 & g4) | (p5 & p4 & g3) | (p5 & p4 & p3 & g2) | (p5 & p4 & p3 & p2 & g1) | (p5 & p4 & p3 & p2 & p1 & g0) | (p5 & p4 & p3 & p2 & p1 & p0 & cin);

assign R[0] = p0 ^ c0;
assign R[1] = p1 ^ c1;
assign R[2] = p2 ^ c2;
assign R[3] = p3 ^ c3;
assign R[4] = p4 ^ c4;
assign R[5] = p5 ^ c5;
assign R[6] = p6 ^ c6;

endmodule