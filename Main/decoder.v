module decoder
(
	input [15:0] instruction1, instruction2, pc,
	input jump,
	
	output [15:0] instr_addr1, instr_addr2, data_addr1, data_addr2, new_pc,
	output cnt_en, pc_sload, instr_Wen2, data_Wen1, data_Wen2
	
);

	// all logic not done yet
	assign instr_addr1 = pc;
	assign instr_addr2 = pc + 1;
	
	assign data_addr1 = 0;
	assign data_addr2 = 0;
	
	assign new_pc = pc;
	
	assign instr_Wen2 = 0;
	assign data_Wen1 = 0;
	assign data_Wen2 = 0;
	
	assign cnt_en = 0;
	assign pc_sload = 0;

endmodule
