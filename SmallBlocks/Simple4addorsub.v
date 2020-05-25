module simple4addorsub
(
input [3:0] A, B,
output [3:0] res,
input sub
);

reg [3:0] result;
assign res = result;
always @(*) begin

	if (sub)
		result = A - B;
	else
		result = A + B;

end

endmodule