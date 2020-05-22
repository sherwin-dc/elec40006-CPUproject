module Demux1
(
	input In,
	input Sel,
	output Out1, Out2

);

reg O1, O2;

always @(*) begin
	case(Sel)
		1'b0: O1 = In;
		1'b1: O2 = In;
	endcase
end

endmodule