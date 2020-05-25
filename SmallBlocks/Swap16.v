module Swap16
(

input [15:0] A_in, B_in,
output [15:0] A_out, B_out,
input swap
);

reg [15:0] A_o;
reg [15:0] B_o;
assign A_out = A_o;
assign B_out = B_o;

always @(*) begin

if(swap) begin
			A_o = B_in;
			B_o = A_in;
			end 
else begin
			A_o = A_in;
			B_o = B_in;
			end
			
end
			
endmodule