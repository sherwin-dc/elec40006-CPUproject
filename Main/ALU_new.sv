module ALU_new
(
	input [15:0] rsdata, rmdata, N,
	input instr_bit_15, 
	input [1:0] instr_bit_12_11,
	output [15:0] aluout
);


wire [2:0] opcode = { instr_bit_15 , instr_bit_12_11[1:0] };

reg [15:0] alusum, A, B, Addout, Subout;
assign aluout = alusum;

adder_to_use_16_bit adder(.A(A), .B(B), .cin(1'b0), .R(Addout));
adder_to_use_16_bit subber(.A(A), .B(~B), .cin(1'b1), .R(Subout));


always @(*)
	begin 
	A = rsdata;
	B = 16'd0;
	
		case (opcode)
			3'b000 : begin // ADD R
			B = rmdata;
			alusum = Addout; 
			end
			
			3'b001 : begin// ADD I
			B = N;
			alusum = Addout; 
			end
			
			3'b010 : begin// SUB R
			B = rmdata;
			alusum = Subout; 
			end
			
			3'b011 : begin// SUB I
			B = N;
			alusum = Subout; 
			end
			
			3'b100 : alusum = {rsdata[14:0], 1'b0}; // LSL
			3'b110 : alusum = {1'b0, rsdata[15:1]}; // LSR
					
			default : alusum = 0;
		endcase
	end
	
endmodule