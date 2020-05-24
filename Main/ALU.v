module ALU
(
	input [15:0] rddata, rsdata, rmdata, N, instruction,
	
	output [15:0] aluout
);


wire [3:0] opcode = instruction[15:12];
wire type = instruction[11]; //type R = 0, type I = 1
wire [2:0] Rd = instruction[10:8];

reg [15:0] alusum;

assign aluout = alusum;

always @(*)
	begin 
		case (opcode)
			5'b01000 : alusum = rsdata + rmdata; // ADD R
			5'b01001 : alusum = rsdata + N; // ADD I
			5'b01010 : alusum = rsdata - rmdata; // SUB R
			5'b01011 : alusum = rsdata - N; // SUB I
			5'b11000 : alusum = {rsdata[14:0], 1'b0}; // LSL
			5'b11010 : alusum = {1'b0, rsdata[15:1]}; // LSR (possibly ASR implementation as well)
			5'b01100 : alusum = rddata * rsdata + rmdata; //MAS R
			5'b01101 : alusum = 0; // MAS I
			5'b01110 : alusum = rsdata; // MOV R
			5'b01111 : alusum = N; // MOV I
			
			
			default : alusum = 0;
		endcase;
	end
	
endmodule