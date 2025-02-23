module ALU_new
(
	input [15:0] rsdata, rmdata, N,
	input instr_bit_15, 
	input instr_bit_4,
	input [1:0] instr_bit_12_11,
	output [15:0] aluout
);


wire [3:0] opcode = { instr_bit_15 , instr_bit_12_11[1:0] , instr_bit_4};

reg [15:0] alusum, A, B, Addout, Subout;
assign aluout = alusum;

adder_to_use_16_bit adder(.A(A), .B(B), .cin(1'b0), .R(Addout));
adder_to_use_16_bit subber(.A(A), .B(~B), .cin(1'b1), .R(Subout));


always @(*)
	begin 
	A = rsdata;
	B = 16'd0;
	
		casex (opcode)
			4'b000x : begin // ADD R
			B = rmdata;
			alusum = Addout; 
			end
			
			4'b001x : begin// ADD I
			B = N;
			alusum = Addout; 
			end
			
			4'b010x : begin// SUB R
			B = rmdata;
			alusum = Subout; 
			end
			
			4'b011x : begin// SUB I
			B = N;
			alusum = Subout; 
			end
			
			
			
			4'b100x : alusum = {rsdata[14:0], 1'b0}; // LSL
			4'b1100 : alusum = {1'b0, rsdata[15:1]}; // LSR
			4'b1101 : alusum = {rsdata[15], rsdata[15:1]}; // ASR
					
			default : alusum = 0;
		endcase
	end
	
endmodule