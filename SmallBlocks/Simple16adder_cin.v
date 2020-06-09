module simple16adder_cin
(
input [15:0] A, B,
input cin,
output [15:0] res
);
wire c;
assign c = cin;

assign res = A[15:0] + B[15:0] + 1;

endmodule