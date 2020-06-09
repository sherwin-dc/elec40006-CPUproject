module alt_carry_look_ahead_adder_cin_4
(
input [3:0] A, B,
input cin,
output [3:0] R,
output cout
);
wire p0,  p1,  p2,  p3; 
wire c0,  c1,  c2,  c3,  c4; 
wire [4:0] c_four;
wire [3:0] c_three;
wire [2:0] c_two;
wire [1:0] c_one;

assign p0 = A[0] ^ B[0];
assign p1 = A[1] ^ B[1];
assign p2 = A[2] ^ B[2];
assign p3 = A[3] ^ B[3];


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

assign c1 = c_one[0] | c_one[1];
assign c2 = c_two[0] | c_two[1] | c_two[2]; 
assign c3 = c_three[0] | c_three[1] | c_three[2] | c_three[3]; 
assign c4 = c_four[0] | c_four[1] | c_four[2] | c_four[3] | c_four[4];

assign R[0] = p0 ^ cin;
assign R[1] = p1 ^ c1;
assign R[2] = p2 ^ c2;
assign R[3] = p3 ^ c3;
assign cout = c4;

endmodule