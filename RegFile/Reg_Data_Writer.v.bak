module Demux16
(
	input [15:0] In,
	input Sel,
	output [15:0] Out1, Out2

);

reg [15:0] O1, O2;
assign Out1 = O1;
assign Out2 = O2;

always @(*) begin
	if(Sel) begin
					O1 = In;
					O2 = 16'h0000;
				end
		else begin
					O1 = 16'h0000;
					O2 = In;	
				end
	
end

endmodule