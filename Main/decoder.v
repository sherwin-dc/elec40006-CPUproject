module decoder
(
	input [15:0] instr, N, pc, rddata, rsdata,
	input jump,
	
	output reg [15:0] data_addr1, data_addr2, new_pc,
	output reg [15:0] instr_addr1, instr_addr2, 
	output reg cnt_en, instr_Wen2, data_wen1, data_wen2, rd_wen, rs_wen, mux1_sel,
	output pc_sload
);

wire [3:0]op = instr[15:12];
wire type = instr[11];

//		STP 	11111
//		CAL   00001
//		RTN	11100
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

wire cmp = !instr[15] & !instr[14] & !instr[13] & instr[12];
wire jmp = !instr[15] & !instr[14] & instr[13] & !instr[12];

always @(*)
	begin
		case (op)
		4'b0001: begin // CMP
						new_pc = (pc + 1 + instr[1:0]) & jump; // skiplen = instr[1:0]
						cnt_en = !jump;
					end 
		4'b0010: begin // JMP
						cnt_en = 0;
						new_pc = (rddata & !type) + (N & type) + 1;
						instr_addr1 = (rddata & !type) + (N & type);
					end
		4'b0100: begin // AND
						rd_wen = 1;
					end 
		4'b0101: begin // SUB
						rd_wen = 1;
					end
		4'b0110: begin // MAS 
						rd_wen = 1;
					end
		4'b0111: begin // MOV
						rd_wen = 1;
					end
		4'b1000: begin // PLD
						rd_wen = instr[3];
						rs_wen = instr[2];
					end
		4'b1001: begin // PST
						data_wen1 = instr[3];
						data_wen2 = instr[2];						
					end
		4'b1011: begin // SET 
					end
						
		
		default: cnt_en = 1;
		endcase	
	end

// if type I instruction should always set new PC value to +2
always @(type, pc)
	begin
		if(type && !jmp && !cmp)
			cnt_en = 0;
			new_pc = pc + 2;
	end

	assign pc_sload = !cnt_en;

endmodule

//	assign instr_addr1 = pc;
//	assign instr_addr2 = pc + 1;

//	assign rs_wen = 0; //only pst 
//	assign mux1_sel = 0; //only pst 
//
//	assign data_addr1 = rddata; //during set and have to keep the data_addr for next cycle
//	assign data_addr2 = rsdata; //during set
//	
//	assign new_pc = 0; //because of pipelining will be different and depends on cond
//	
//	assign instr_Wen2 = 0; // only for writing self-modifying instructions
//	assign data_Wen1 = instr[3]; // pst and port A enabled
//	assign data_Wen2 = instr[2]; // pst and port B enabled
//	
//	assign cnt_en = 1; //except jumps and cmp conditional jumps