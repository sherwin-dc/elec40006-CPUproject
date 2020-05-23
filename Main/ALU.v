module ALU
(
	input [15:0] rddata, rsdata, rmdata, N, instruction,
	
	output [15:0] aluout,
	output Rd_Wen, Rs_Wen

);


wire [3:0] opcode = instruction[15:12];
wire type = instruction[11]; //type R = 0, type I = 1
wire [2:0] Rd = instruction[10:8];

reg [15:0] alusum;

assign aluout = alusum;

always @(*)
	begin 
		case (opcode)
			5'b01000 : alusum = rsdata + rmdata;
			5'b01001 : alusum = rsdata + N;
			default : alusum = 0;
		endcase;
	end
	
endmodule