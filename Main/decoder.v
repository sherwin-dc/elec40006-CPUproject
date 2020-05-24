module decoder
(
	input [15:0] instr, N, pc, rddata, rsdata,
	input jump,
	
	output [15:0] instr_addr1, instr_addr2, data_addr1, data_addr2, new_pc,
	output cnt_en, pc_sload, instr_Wen2, data_Wen1, data_Wen2, rd_wen, rs_wen, mux1_sel
	
);
	
wire [4:0]op = instr[15:11];


//		STP	11111
//		CALL	00001
//		RTN	
//		LSL	11000
//		LSR	11010
//		CMP	0001x
//		JMP	0010x
//		ADD	0100x
//		SUB	0101x
//		MAS	0110x
//		MOV	0111x
//		SET	1011x
//		PLD	10000
//		PST	10010
//		NOP	00000
	
	
	assign instr_addr1 = pc;
	assign instr_addr2 = pc + 1;
	
	assign rs_wen = 0; //only pst 
	assign mux1_sel = 0; //only pst 

	assign data_addr1 = rddata; //during set and have to keep the data_addr for next cycle
	assign data_addr2 = rsdata; //during set
	
	assign new_pc = 0; //because of pipelining will be different and depends on cond
	
	assign instr_Wen2 = 0; // only for writing self-modifying instructions
	assign data_Wen1 = instr[3]; // pst and port A enabled
	assign data_Wen2 = instr[2]; // pst and port B enabled
	
	assign cnt_en = 1; //except jumps and cmp conditional jumps
	assign pc_sload = !cnt_en;

endmodule
