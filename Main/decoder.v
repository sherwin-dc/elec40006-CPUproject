module decoder
(
	input [15:0] instr, N, pc, rddata, rsdata,
	input jump,
	
	output reg [15:0] instr_addr1, instr_addr2, data_addr1, data_addr2, new_pc,
	output reg [2:0] giantmux_sel,
	output instr_wen2, data_wen1, data_wen2, rd_wen, rs_wen, move_fp, push_up, cnt_en, pc_sload, rsmux_sel, dataA_addr_wen, dataB_addr_wen, 
	output IR_addr_regSel, IR_addr_wren
);

wire [9:0] i = {instr[15:11], instr[4:0]}; // wire for inputs
wire jmp = jump;
reg [11:0] o;
reg [1:0] ir;

assign {instr_wen2, data_wen1, data_wen2, rd_wen, rs_wen, move_fp, push_up, cnt_en, pc_sload, rsmux_sel, dataA_addr_wen, dataB_addr_wen} = o;
assign {IR_addr_regSel, IR_addr_wren} = ir;

always @(*)
	begin
	
// initial values to prevent latches from being inferred
instr_addr1 = 16'b0;
instr_addr2 = 16'b0;
data_addr1 = 16'b0;
data_addr2 = 16'b0;
giantmux_sel = 3'b0;
new_pc = 16'b0;
ir = 2'b00;


		casex (i)
		10'b00000xxxxx: // NOP
		begin 
			o = 12'b000000010x00;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end

		10'b00001xxxxx: // CALL
		begin
			o = 12'b000101001x00;
			giantmux_sel = 3'b001; // PC
			instr_addr1 = N;
			instr_addr2 = N + 1'd1;
			new_pc = N + 1'd1;
		end

		10'b11100xxxxx: // RTN
		begin
			o = 12'b000001101x00;
			instr_addr1 = rddata;
			instr_addr2 = rddata + 1'd1;
			new_pc = rddata + 1'd1;
		end

		10'b110x0xxxxx: // LSL and/or LSR
		begin
			o = 12'b000100010x00;
			giantmux_sel = 3'b100; // aluout
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end 

		10'b00010xxxxx: // failed CMP R
		begin 
			if(jmp) begin // passed jump
				o = 12'b000000001x00;
				instr_addr1 = pc + instr[1:0] + 2'd1;
				instr_addr2 = pc + instr[1:0] + 2'd2; 
				new_pc = pc + instr[1:0] + 2'd2;
			end else begin // failed jump
				o = 12'b000000010x00;
				instr_addr1 = pc;
				instr_addr2 = pc + 1'd1;
			end
			
		end
		
		10'b00011xxxxx: // failed CMP I
		begin 
			if(jmp) begin //passed jump
				o = 12'b000000001x00;
				instr_addr1 = pc + instr[1:0] + 2'd2;
				instr_addr2 = pc + instr[1:0] + 3'd3; 
				new_pc = pc + instr[1:0] + 3'd3;
			end else begin //failed jump
				o = 12'b000000001x00;
				instr_addr1 = pc + 1'd1;
				instr_addr2 = pc + 2'd2;
				new_pc = pc + 2'd2;
			end
			
		end

		
		10'b00100xxxxx: // JMP R
		begin
			o = 12'b000000001x00;
			instr_addr1 = rddata;
			instr_addr2 = rddata + 1'd1;
			new_pc = rddata + 1'd1;
		end 

		10'b00101xxxxx: // JMP I
		begin
			o = 12'b000000001x00;
			instr_addr1 = N;
			instr_addr2 = N + 1'd1;
			new_pc = N + 1'd1;
		end 

		10'b0100xxxxxx: // ADD R and/or I
		begin
			o = {7'b0001000, !instr[11], instr[11], 3'bx00};
			instr_addr1 = pc + instr[11];
			instr_addr2 = pc + instr[11] + 1'd1;
			new_pc = pc + instr[11] + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end 

		10'b01010xxx0x: // SUB R, no jump cond 
		begin 
			o = 12'b000100010x00;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end 

		10'b01010xxx1x: // SUB R, jump cond failed
		begin 
			if(jmp) begin //passed jump
				o = 12'b000100001x00;
				instr_addr1 = pc + instr[0] + 1'd1;
				instr_addr2 = pc + instr[0] + 2'd2;
				new_pc = pc + instr[0] + 2'd2;
				giantmux_sel = 3'b100; // aluout
			end else begin //failed jump
				o = 12'b000100010x00;
				instr_addr1 = pc;
				instr_addr2 = pc + 1'd1;
				giantmux_sel = 3'b100; // aluout
			end
			
		end


		10'b01011xxx0x: // SUB I, no jump cond
		begin
			o = 12'b000100001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		10'b01011xxx1x: // SUB I, jump cond failed
		begin
			if(jmp) begin //passed jump
				o = 12'b000100001x00;
				instr_addr1 = pc + instr[0] + 2'd2;
				instr_addr2 = pc + instr[0] + 2'd3;
				new_pc = pc + instr[0] + 2'd3;
				giantmux_sel = 3'b100; // aluout
			end else begin //failed jump
				o = 12'b000100001x00;
				instr_addr1 = pc + 1'd1;
				instr_addr2 = pc + 2'd2;
				new_pc = pc + 2'd2;
				giantmux_sel = 3'b100; // aluout
			end
			
		end 


		10'b0110xxxxxx: // MAS R and/or I
		begin 
			o = {7'b0001000, !instr[11], instr[11], 3'bx00};
			instr_addr1 = pc + instr[11];
			instr_addr2 = pc + instr[11] + 1'd1;
			new_pc = pc + instr[11] + 1'd1;
			giantmux_sel = 3'b101; // masout
		end 

		10'b0111xxxxxx: // MOV R and/or I
		begin 
			o = {7'b0001000, !instr[11], instr[11], 3'bx00};
			instr_addr1 = pc + instr[11];
			instr_addr2 = pc + instr[11] + 1'd1;
			new_pc = pc + instr[11] + 1'd1;
			giantmux_sel = {1'b0, instr[11], 1'b0}; // rsdata = 000, N = 010
		end

		10'b11111xxxxx: // STP
		begin
			o = 12'b000000000x00;
			instr_addr1 = pc - 1'd1;
			instr_addr2 = pc;
		end

		10'b101100xxxx: // SET R, data, set A and/or B
		begin 
			o = {10'b000000010x, instr[3], instr[2]};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			data_addr1 = rddata;
			data_addr2 = rsdata;
		end

		10'b101101x1xx: // SET R, instruction, set B
		begin 
			o = 12'b000000010x00;
			instr_addr1 = pc;
			instr_addr2 = rsdata;
			ir = 2'b11;
		end

		10'b101110xx00: // SET I, data, set A and/or B, no offset
		begin 
			o = {10'b000000010x, instr[3], instr[2]};
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = N;
			data_addr2 = rsdata;
		end

		10'b10111001x1: // SET I, data, set B, offset
		begin 
			o = 12'b000000001x01;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr2 = rsdata + N;
		end

		10'b101110101x: // SET I, data, set A, offset
		begin 
			o = 12'b000000001x10;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
		end

		10'b1011101110: // SET I, data, set A & B, offset A
		begin 
			o = 12'b000000001x11;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
			data_addr2 = rsdata;
		end

		10'b1011101101: // SET I, data, set A & B, offset B
		begin 
			o = 12'b000000001x11;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata;
			data_addr2 = rsdata + N;
		end

		10'b1011101111: // SET I, data, set A & B, offset both
		begin 
			o = 12'b000000001x11;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
			data_addr2 = rsdata + N;
		end

		10'b101111x100: // SET I, instruction, set B, no offset
		begin 
			o = 12'b000000001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = rsdata;
			new_pc = pc + 2'd2;
			ir = 2'b11;
		end

		10'b101111x1x1: // SET I, instruction, set B, offset
		begin 
			o = 12'b000000001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = rsdata + N;
			new_pc = pc + 2'd2;
			ir = 2'b11;
		end

		10'b1000xxxxxx: // PLD A and/or B, data and/or instruction
		begin 
			o = {3'b000, instr[3], instr[2], 4'b0010, instr[4], 2'b00};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = {!instr[4], 1'b1, instr[4]}; // 110 = data_out1, 011 = instr_out1
		end

		10'b1001x0xxxx: // PST A and/or B, data
		begin 
			o = {1'b0, instr[3], instr[2], 8'b000010x00};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end

		10'b1001x1xxxx: // PST A and/or B, instruction
		begin 
			o = {12'b100000010x00};
			instr_addr1 = pc;
			ir = 2'b10;
		end

		default: // current default is STP, maybe default to NOP?
		begin
			o = 12'b000000000x00;
			instr_addr1 = pc - 1'b1;
			instr_addr2 = pc;
		end

		endcase	
	end

endmodule
