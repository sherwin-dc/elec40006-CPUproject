module Giant8MUX
(
input [15:0] I0, I1, I2, I3, I4, I5, I6, I7,
input [2:0] Sel,
output [15:0] Out
);

reg [15:0] O;
assign Out = O;

always @(*) begin
	
	case(Sel)
		3'd0 : O = I0;
		3'd1 : O = I1;
		3'd2 : O = I2;
		3'd3 : O = I3;
		3'd4 : O = I4;
		3'd5 : O = I5;
		3'd6 : O = I6;
		3'd7 : O = I7;
	endcase

end


endmodule