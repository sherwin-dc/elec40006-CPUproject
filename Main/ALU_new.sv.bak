module ALU
(
	input [15:0] rsdata, rmdata, N,
	input instr_bit_15, 
	input [1:0] instr_bit_12_11,
	output [15:0] aluout
);


wire [2:0] opcode = { instr_bit_15 , instr_bit_12_11[1:0] };

reg [15:0] alusum;

assign aluout = alusum;

always @(*)
	begin 
		case (opcode)
			3'b000 : alusum = rsdata + rmdata; // ADD R
			3'b001 : alusum = rsdata + N; // ADD I
			3'b010 : alusum = rsdata - rmdata; // SUB R
			3'b011 : alusum = rsdata - N; // SUB I
			3'b100 : alusum = {rsdata[14:0], 1'b0}; // LSL
			3'b110 : alusum = {1'b0, rsdata[15:1]}; // LSR
					
			default : alusum = 0;
		endcase
	end
	
endmodule