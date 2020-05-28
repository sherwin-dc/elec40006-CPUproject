module carry_look_ahead_adder_cin
(
input [15:0] A, B,
input cin,
output [15:0] R
);
wire p0,  p1,  p2,  p3,  p4,  p5,  p6,  p7,  p8,  p9,  p10, p11, p12, p13, p14, p15; 
wire g0,  g1,  g2,  g3,  g4,  g5,  g6,  g7,  g8,  g9,  g10, g11, g12, g13, g14, g15; 
wire c0,  c1,  c2,  c3,  c4,  c5,  c6,  c7,  c8,  c9,  c10, c11, c12, c13, c14, c15; 

assign p0 = A[0] ^ B[0];
assign p1 = A[1] ^ B[1];
assign p2 = A[2] ^ B[2];
assign p3 = A[3] ^ B[3];
assign p4 = A[4] ^ B[4];
assign p5 = A[5] ^ B[5];
assign p6 = A[6] ^ B[6];
assign p7 = A[7] ^ B[7];
assign p8 = A[8] ^ B[8];
assign p9 = A[9] ^ B[9];
assign p10 = A[10] ^ B[10];
assign p11 = A[11] ^ B[11];
assign p12 = A[12] ^ B[12];
assign p13 = A[13] ^ B[13];
assign p14 = A[14] ^ B[14];
assign p15 = A[15] ^ B[15];

assign g0 = A[0] & B[0];
assign g1 = A[1] & B[1];
assign g2 = A[2] & B[2];
assign g3 = A[3] & B[3];
assign g4 = A[4] & B[4];
assign g5 = A[5] & B[5];
assign g6 = A[6] & B[6];
assign g7 = A[7] & B[7];
assign g8 = A[8] & B[8];
assign g9 = A[9] & B[9];
assign g10 = A[10] & B[10];
assign g11 = A[11] & B[11];
assign g12 = A[12] & B[12];
assign g13 = A[13] & B[13];
assign g14 = A[14] & B[14];
//assign g15 = A[15] & B[15];

assign c0 = cin;
assign c1 = g0 | (p0 & cin);
assign c2 = g1 | (p1 & g0) | (p1 & p0 & cin);
assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & cin);
assign c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & cin);
assign c5 = g4 | (p4 & g3) | (p4 & p3 & g2) | (p4 & p3 & p2 & g1) | (p4 & p3 & p2 & p1 & g0) | (p4 & p3 & p2 & p1 & p0 & cin);
assign c6 = g5 | (p5 & g4) | (p5 & p4 & g3) | (p5 & p4 & p3 & g2) | (p5 & p4 & p3 & p2 & g1) | (p5 & p4 & p3 & p2 & p1 & g0) | (p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c7 = g6 | (p6 & g5) | (p6 & p5 & g4) | (p6 & p5 & p4 & g3) | (p6 & p5 & p4 & p3 & g2) | (p6 & p5 & p4 & p3 & p2 & g1) | (p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c8 = g7 | (p7 & g6) | (p7 & p6 & g5) | (p7 & p6 & p5 & g4) | (p7 & p6 & p5 & p4 & g3) | (p7 & p6 & p5 & p4 & p3 & g2) | (p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c9 = g8 | (p8 & g7) | (p8 & p7 & g6) | (p8 & p7 & p6 & g5) | (p8 & p7 & p6 & p5 & g4) | (p8 & p7 & p6 & p5 & p4 & g3) | (p8 & p7 & p6 & p5 & p4 & p3 & g2) | (p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c10 = g9 | (p9 & g8) | (p9 & p8 & g7) | (p9 & p8 & p7 & g6) | (p9 & p8 & p7 & p6 & g5) | (p9 & p8 & p7 & p6 & p5 & g4) | (p9 & p8 & p7 & p6 & p5 & p4 & g3) | (p9 & p8 & p7 & p6 & p5 & p4 & p3 & g2) | (p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c11 = g10 | (p10 & g9) | (p10 & p9 & g8) | (p10 & p9 & p8 & g7) | (p10 & p9 & p8 & p7 & g6) | (p10 & p9 & p8 & p7 & p6 & g5) | (p10 & p9 & p8 & p7 & p6 & p5 & g4) | (p10 & p9 & p8 & p7 & p6 & p5 & p4 & g3) | (p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & g2) | (p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c12 = g11 | (p11 & g10) | (p11 & p10 & g9) | (p11 & p10 & p9 & g8) | (p11 & p10 & p9 & p8 & g7) | (p11 & p10 & p9 & p8 & p7 & g6) | (p11 & p10 & p9 & p8 & p7 & p6 & g5) | (p11 & p10 & p9 & p8 & p7 & p6 & p5 & g4) | (p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & g3) | (p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & g2) | (p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c13 = g12 | (p12 & g11) | (p12 & p11 & g10) | (p12 & p11 & p10 & g9) | (p12 & p11 & p10 & p9 & g8) | (p12 & p11 & p10 & p9 & p8 & g7) | (p12 & p11 & p10 & p9 & p8 & p7 & g6) | (p12 & p11 & p10 & p9 & p8 & p7 & p6 & g5) | (p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & g4) | (p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & g3) | (p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & g2) | (p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c14 = g13 | (p13 & g12) | (p13 & p12 & g11) | (p13 & p12 & p11 & g10) | (p13 & p12 & p11 & p10 & g9) | (p13 & p12 & p11 & p10 & p9 & g8) | (p13 & p12 & p11 & p10 & p9 & p8 & g7) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & g6) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & g5) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & g4) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & g3) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & g2) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);
assign c15 = g14 | (p14 & g13) | (p14 & p13 & g12) | (p14 & p13 & p12 & g11) | (p14 & p13 & p12 & p11 & g10) | (p14 & p13 & p12 & p11 & p10 & g9) | (p14 & p13 & p12 & p11 & p10 & p9 & g8) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & g7) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & g6) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & g5) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & g4) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & g3) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & g2) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & g0) | (p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & cin);

assign R[0] = p0 ^ c0;
assign R[1] = p1 ^ c1;
assign R[2] = p2 ^ c2;
assign R[3] = p3 ^ c3;
assign R[4] = p4 ^ c4;
assign R[5] = p5 ^ c5;
assign R[6] = p6 ^ c6;
assign R[7] = p7 ^ c7;
assign R[8] = p8 ^ c8;
assign R[9] = p9 ^ c9;
assign R[10] = p10 ^ c10;
assign R[11] = p11 ^ c11;
assign R[12] = p12 ^ c12;
assign R[13] = p13 ^ c13;
assign R[14] = p14 ^ c14;
assign R[15] = p15 ^ c15;

endmodule