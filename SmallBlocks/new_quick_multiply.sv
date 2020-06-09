module new_quick_multiply
(
input reg [15:0] A, B,
output reg [15:0] Out,
input clk

);

reg [15:0][15:0] R;
reg [7:0][15:0] A1;
reg [3:0][15:0] A2, B2;
reg [1:0][15:0] A3;

Multiply16logic Mult_logic(.A(A) , .B(B) , .R(R));
adder_to_use_16_bit Add1(.A(R[0][15:0]) , .B(R[1][15:0]) , .cin(1'b0) , .R(A1[0][15:0]));
adder_to_use_16_bit Add2(.A(R[2][15:0]) , .B(R[3][15:0]) , .cin(1'b0) , .R(A1[1][15:0]));
adder_to_use_16_bit Add3(.A(R[4][15:0]) , .B(R[5][15:0]) , .cin(1'b0) , .R(A1[2][15:0]));
adder_to_use_16_bit Add4(.A(R[6][15:0]) , .B(R[7][15:0]) , .cin(1'b0) , .R(A1[3][15:0]));
adder_to_use_16_bit Add5(.A(R[8][15:0]) , .B(R[9][15:0]) , .cin(1'b0) , .R(A1[4][15:0]));
adder_to_use_16_bit Add6(.A(R[10][15:0]) , .B(R[11][15:0]) , .cin(1'b0) , .R(A1[5][15:0]));
adder_to_use_16_bit Add7(.A(R[12][15:0]) , .B(R[13][15:0]) , .cin(1'b0) , .R(A1[6][15:0]));
adder_to_use_16_bit Add8(.A(R[14][15:0]) , .B(R[15][15:0]) , .cin(1'b0) , .R(A1[7][15:0]));

adder_to_use_16_bit Add9(.A(A1[0][15:0]) , .B(A1[1][15:0]) , .cin(1'b0) , .R(A2[0][15:0]));
adder_to_use_16_bit Add10(.A(A1[2][15:0]) , .B(A1[3][15:0]) , .cin(1'b0) , .R(A2[1][15:0]));
adder_to_use_16_bit Add11(.A(A1[4][15:0]) , .B(A1[5][15:0]) , .cin(1'b0) , .R(A2[2][15:0]));
adder_to_use_16_bit Add12(.A(A1[6][15:0]) , .B(A1[7][15:0]) , .cin(1'b0) , .R(A2[3][15:0]));

// Split MAS here
Hold_registers_4 Holdregisters(.In(A2) , .clk(clk) , .RegOut(B2));
////////////////
adder_to_use_16_bit Add13(.A(B2[0][15:0]) , .B(B2[1][15:0]) , .cin(1'b0) , .R(A3[0][15:0]));
adder_to_use_16_bit Add14(.A(B2[2][15:0]) , .B(B2[3][15:0]) , .cin(1'b0) , .R(A3[1][15:0]));

adder_to_use_16_bit Add15(.A(A3[0][15:0]) , .B(A3[1][15:0]) , .cin(1'b0) , .R(Out));

endmodule

module Hold_registers_4
(
input [3:0][15:0] In,
output [3:0][15:0] RegOut,
input clk

);

integer i;

reg [3:0][15:0] Registers;

always @(*) begin
	for(i=0 ; i<4 ; i=i+1) begin
		RegOut[i][15:0] = Registers[i][15:0];

	end

end

always @(posedge clk) begin

	for(i=0 ; i<4 ; i=i+1) begin
		Registers[i][15:0] <= In[i][15:0];

	end

end

endmodule
