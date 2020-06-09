module alt_carry_look_ahead_adder_cin_6
(
input [5:0] A, B,
input cin,
output [5:0] R,
output cout
);
wire p0,  p1,  p2,  p3,  p4,  p5; 
wire c0,  c1,  c2,  c3,  c4,  c5,  c6; 
wire [6:0] c_six;
wire [5:0] c_five;
wire [4:0] c_four;
wire [3:0] c_three;
wire [2:0] c_two;
wire [1:0] c_one;

assign p0 = A[0] ^ B[0];
assign p1 = A[1] ^ B[1];
assign p2 = A[2] ^ B[2];
assign p3 = A[3] ^ B[3];
assign p4 = A[4] ^ B[4];
assign p5 = A[5] ^ B[5];


and(c_one[0] , A[0] , B[0]); 
 and(c_one[1] , p0 , cin);
and(c_two[0] , A[1] , B[1]); 
 and(c_two[1] , p1 , A[0] , B[0]); 
 and(c_two[2] , p1 , p0 , cin);
and(c_three[0] , A[2] , B[2]); 
 and(c_three[1] , p2 , A[1] , B[1]); 
 and(c_three[2] , p2 , p1 , A[0] , B[0]); 
 and(c_three[3] , p2 , p1 , p0 , cin);
and(c_four[0] , A[3] , B[3]); 
 and(c_four[1] , p3 , A[2] , B[2]); 
 and(c_four[2] , p3 , p2 , A[1] , B[1]); 
 and(c_four[3] , p3 , p2 , p1 , A[0] , B[0]); 
 and(c_four[4] , p3 , p2 , p1 , p0 , cin);
and(c_five[0] , A[4] , B[4]); 
 and(c_five[1] , p4 , A[3] , B[3]); 
 and(c_five[2] , p4 , p3 , A[2] , B[2]); 
 and(c_five[3] , p4 , p3 , p2 , A[1] , B[1]); 
 and(c_five[4] , p4 , p3 , p2 , p1 , A[0] , B[0]); 
 and(c_five[5] , p4 , p3 , p2 , p1 , p0 , cin);
and(c_six[0] , A[5] , B[5]); 
 and(c_six[1] , p5 , A[4] , B[4]); 
 and(c_six[2] , p5 , p4 , A[3] , B[3]); 
 and(c_six[3] , p5 , p4 , p3 , A[2] , B[2]); 
 and(c_six[4] , p5 , p4 , p3 , p2 , A[1] , B[1]); 
 and(c_six[5] , p5 , p4 , p3 , p2 , p1 , A[0] , B[0]); 
 and(c_six[6] , p5 , p4 , p3 , p2 , p1 , p0 , cin);

assign c1 = c_one[0] | c_one[1];
assign c2 = c_two[0] | c_two[1] | c_two[2]; 
assign c3 = c_three[0] | c_three[1] | c_three[2] | c_three[3]; 
assign c4 = c_four[0] | c_four[1] | c_four[2] | c_four[3] | c_four[4];
assign c5 = c_five[0] | c_five[1] | c_five[2] | c_five[3] | c_five[4] | c_five[5];
assign c6 = c_six[0] | c_six[1] | c_six[2] | c_six[3] | c_six[4] | c_six[5] | c_six[6];

assign R[0] = p0 ^ cin;
assign R[1] = p1 ^ c1;
assign R[2] = p2 ^ c2;
assign R[3] = p3 ^ c3;
assign R[4] = p4 ^ c4;
assign R[5] = p5 ^ c5;
assign cout = c6;

endmodule