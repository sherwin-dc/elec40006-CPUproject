module Demux16
(
	input [15:0] In,
	input Sel,
	output [15:0] Out1, Out2

);

wire [15:0] O1;
wire [15:0] O2;

assign Out1 = O1;
assign Out2 = O2;

always @(*) begin
	if(Sel==0)
		Out1 = In;
	else
		assign Out2 = In;
	
end

endmodule