module simple7addorsub
(
input [6:0] A, B,
output [6:0] res,
input sub
);

reg [6:0] result;
assign res = result;
always @(*) begin

	if (sub)
		result = A - B;
	else
		result = A + B;

end

endmodule