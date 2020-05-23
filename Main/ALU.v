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
assign rs_wen = 0;//pst instruction
assign mux1_sel = 0;//pst instruction

always @(*)
	begin 
		case (opcode)
			5'b01000 : alusum = rsdata + rmdata;
			5'b01001 : alusum = rsdata + N;
			default : alusum = 0;
		endcase;
	end
	
endmodule