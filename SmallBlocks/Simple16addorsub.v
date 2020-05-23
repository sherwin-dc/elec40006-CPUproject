module simple16addorsub
(
input [15:0] A, B,
output [15:0] res,
input sub
);

reg [15:0] result;
assign res = result;
always @(*) begin

	if (sub)
		result = A - B;
	else
		result = A + B;

end

endmodule