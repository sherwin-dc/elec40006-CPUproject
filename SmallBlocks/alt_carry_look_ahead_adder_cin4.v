module alt_carry_look_ahead_adder_cin4
(
input [3:0] A, B,
input cin,
output [3:0] R
);
wire c0,  c1,  c2,  c3; 
wire c_one_1, c_one_2, c_one_3;
wire c_two_1, c_two_2, c_two_3, c_two_4, c_two_5, c_two_6, c_two_7;
wire c_three_1,c_three_2,c_three_3,c_three_4,c_three_5,c_three_6,c_three_7,c_three_8,c_three_9,c_three_10,c_three_11,c_three_12,c_three_13,c_three_14,c_three_15;


assign c0 = cin;
and(c_one_1 ,A[0],B[0]);
and(c_one_2 ,A[0],c0);
and(c_one_3 ,B[0],c0);
and(c_two_1 ,A[1],B[1]);
and(c_two_2 ,A[1],A[0],B[0]);
and(c_two_3 ,A[1],A[0],c0);
and(c_two_4 ,A[1],B[0],c0);
and(c_two_5 ,B[1],A[0],B[0]);
and(c_two_6 ,B[1],A[0],c0);
and(c_two_7 ,B[1],B[0],c0);
and(c_three_1 ,A[2],B[2]);
and(c_three_2 ,A[2],A[1],B[1]);
and(c_three_3 ,A[2],A[1],A[0],B[0]);
and(c_three_4 ,A[2],A[1],A[0],c0);
and(c_three_5 ,A[2],A[1],B[0],c0);
and(c_three_6 ,A[2],B[1],A[0],B[0]);
and(c_three_7 ,A[2],B[1],A[0],c0);
and(c_three_8 ,A[2],B[1],B[0],c0);
and(c_three_9 ,B[2],A[1],B[1]);
and(c_three_10 ,B[2],A[1],A[0],B[0]);
and(c_three_11 ,B[2],A[1],A[0],c0);
and(c_three_12 ,B[2],A[1],B[0],c0);
and(c_three_13 ,B[2],B[1],A[0],B[0]);
and(c_three_14 ,B[2],B[1],A[0],c0);
and(c_three_15 ,B[2],B[1],B[0],c0);



assign c1 = c_one_1| c_one_2| c_one_3;
assign c2 = c_two_1| c_two_2| c_two_3| c_two_4| c_two_5| c_two_6| c_two_7;
assign c3 = c_three_1|c_three_2|c_three_3|c_three_4|c_three_5|c_three_6|c_three_7|c_three_8|c_three_9|c_three_10|c_three_11|c_three_12|c_three_13|c_three_14|c_three_15;



assign R[0] = A[0] ^ B[0] ^ c0;
assign R[1] = A[1] ^ B[1] ^ c1;
assign R[2] = A[2] ^ B[2] ^ c2;
assign R[3] = A[3] ^ B[3] ^ c3;



endmodule
