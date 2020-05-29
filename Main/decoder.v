module decoder
(
	input [15:0] instr, N, pc, rddata, rsdata,
	input jump,
	
	output reg [15:0] instr_addr1, instr_addr2, data_addr1, data_addr2, new_pc,
	output reg [2:0] giantmux_sel,
	output instr_wen2, data_wen1, data_wen2, rd_wen, rs_wen, move_fp, push_up, cnt_en, pc_sload, rsmux_sel, dataA_addr_wen, dataB_addr_wen 
);

wire [12:0] i = {instr[15:11], instr[4:0], jump}; // wire for inputs
reg [11:0] o;

assign {instr_wen2, data_wen1, data_wen2, rd_wen, rs_wen, move_fp, push_up, cnt_en, pc_sload, rsmux_sel, dataA_addr_wen, dataB_addr_wen} = o;

always @(*)
	begin
	
// initial values to prevent latches from being inferred
instr_addr1 = 16'b0;
instr_addr2 = 16'b0;
data_addr1 = 16'b0;
data_addr2 = 16'b0;
giantmux_sel = 3'b0;
new_pc = 16'b0;


		casex (i)
		11'b00000xxxxxx: // NOP
		begin 
			o = 12'b000000010x00;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end

		11'b00001xxxxxx: // CALL
		begin 
			o = 12'b000101001x00;
			giantmux_sel = 3'b001; // PC
			instr_addr1 = N;
			instr_addr2 = N + 1'd1;
			new_pc = N + 1'd1;
		end

		11'b11100xxxxxx: // RTN
		begin
			o = 12'b000001101x00;
			instr_addr1 = rddata;
			instr_addr2 = rddata + 1'd1;
			new_pc = rddata + 1'd1;
		end

		11'b110x0xxxxxx: // LSL and/or LSR
		begin
			o = 12'b000100010x00;
			giantmux_sel = 3'b100; // aluout
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end 

		11'b0001xxxxxx0: // failed CMP 
		begin 
			o = 12'b000000010x00;
			instr_addr1 = pc + instr[11];
			instr_addr2 = pc + instr[11] + 1'd1;
		end

		11'b0001xxxxxx1: // CMP passed 
		begin
			o = 12'b000000001x00;
			instr_addr1 = pc + instr[11] + instr[1:0];
			instr_addr2 = pc + instr[11] + instr[1:0] + 1'd1; 
			new_pc = pc + instr[11] + instr[1:0] + 1'd1;
		end 

		11'b00100xxxxxx: // JMP R
		begin
			o = 12'b000000001x00;
			instr_addr1 = rddata;
			instr_addr2 = rddata + 1'd1;
			new_pc = rddata + 1'd1;
		end 

		11'b00101xxxxxx: // JMP I
		begin
			o = 12'b000000001x00;
			instr_addr1 = N;
			instr_addr2 = N + 1'd1;
			new_pc = N + 1'd1;
		end 

		11'b0100xxxxxx: // ADD R and/or I
		begin
			o = 12'b000100010x00;
			o = {7'b0001000, !instr[11], instr[11], 1'bx};
			instr_addr1 = pc + instr[11];
			instr_addr2 = pc + instr[11] + 1'd1;
			new_pc = pc + instr[11] + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01001xxxxxx: // ADD I
		begin
			o = 12'b000100001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01010xxx0xx: // SUB R, no jump cond 
		begin 
			o = 12'b000100010x00;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01010xxx1x0: // SUB R, jump cond failed
		begin 
			o = 12'b000100010x00;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end

		11'b01010xxx1x1: // SUB R, jump passed, next instruction R and/or I
		begin
			o = 12'b000100001x00;
			instr_addr1 = pc + instr[0] + 1'd1;
			instr_addr2 = pc + instr[0] + 2'd2;
			new_pc = pc + instr[0] + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01011xxx0xx: // SUB I, no jump cond
		begin
			o = 12'b000100001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01011xxx1x0: // SUB I, jump cond failed
		begin
			o = 12'b000100001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01011xxx1x1: // SUB I, jump passed, next instruction R and/or I
		begin 
			o = 12'b000100001x00;
			instr_addr1 = pc + instr[0] + 2'd2;
			instr_addr2 = pc + instr[0] + 2'd3;
			new_pc = pc + instr[0] + 2'd3;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b0110xxxxxxx: // MAS R and/or I
		begin 
			o = {7'b0001000, !instr[11], instr[11], 3'bx00};
			instr_addr1 = pc + instr[11];
			instr_addr2 = pc + instr[11] + 1'd1;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b101; // masout
		end 

		11'b0111xxxxxxx: // MOV R and/or I
		begin 
			o = {7'b0001000, !instr[11], instr[11], 3'bx00};
			instr_addr1 = pc + instr[11];
			instr_addr2 = pc + instr[11] + 1'd1;
			new_pc = pc + 2'd2;
			giantmux_sel = {1'b0, instr[11], 1'b0}; // rsdata = 000, N = 010
		end

		11'b11111xxxxxx: // STP
		begin
			o = 12'b000000000x00;
			instr_addr1 = pc - 1'd1;
			instr_addr2 = pc;
		end

		11'b10110001xxx: // SET R, data, set B only
		begin 
			o = 12'b000000010x01;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			data_addr2 = rsdata;
		end

		11'b10110010xxx: // SET R, data, set A only
		begin 
			o = 12'b000000010x10;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			data_addr1 = rddata;
		end

		11'b10110011xxx: // SET R, data, set A & B
		begin 
			o = 12'b000000010x11;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			data_addr1 = rddata;
			data_addr2 = rsdata;
		end

		11'b101101x1xxx: // SET R, instruction, set B only
		begin 
			o = 12'b000000010x00;
			instr_addr1 = pc;
			instr_addr2 = rsdata;
		end

		11'b1011100100x: // SET I, data, set B, no offset
		begin 
			o = 12'b000000001x01;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr2 = rsdata;
		end

		11'b1011101000x: // SET I, data, set A, no offset
		begin 
			o = 12'b000000001x10;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = N;
		end

		11'b1011101100x: // SET I, data, set A & B, no offset
		begin 
			o = 12'b000000001x11;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = N;
			data_addr2 = rsdata;
		end

		11'b10111001x1x: // SET I, data, set B, offset
		begin 
			o = 12'b000000001x01;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr2 = rsdata + N;
		end

		11'b101110101xx: // SET I, data, set A, offset
		begin 
			o = 12'b000000001x10;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
		end

		11'b1011101110x: // SET I, data, set A & B, offset A
		begin 
			o = 12'b000000001x11;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
			data_addr2 = rsdata;
		end

		11'b1011101101x: // SET I, data, set A & B, offset B
		begin 
			o = 12'b000000001x11;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata;
			data_addr2 = rsdata + N;
		end

		11'b1011101111x: // SET I, data, set A & B, offset both
		begin 
			o = 12'b000000001x11;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
			data_addr2 = rsdata + N;
		end

		11'b101111x100x: // SET I, instruction, set B, no offset
		begin 
			o = 12'b000000001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = rsdata;
			new_pc = pc + 2'd2;
		end

		11'b101111x1x1x: // SET I, instruction, set B, offset
		begin 
			o = 12'b000000001x00;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = rsdata + N;
			new_pc = pc + 2'd2;
		end

		11'b1000xxxxxxx: // PLD A and/or B, data and/or instruction
		begin 
			o = {3'b000, instr[3], instr[2], 4'b0010, instr[4], 2'b00};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = {!instr[4], 1'b1, instr[4]}; // 110 = data_out1, 011 = instr_out1
		end

		11'b1001x0xxxxx: // PST A and/or B, data
		begin 
			o = {1'b0, instr[3], instr[2], 8'b000010x00};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end

		11'b1001x1xxxxx: // PST A and/or B, instruction
		begin 
			o = {12'b100000010x00};
			instr_addr1 = pc;
		end

		default: // current default is STP
		begin
			o = 12'b000000000x00;
			instr_addr1 = pc - 1'b1;
			instr_addr2 = pc;
		end

		endcase	
	end

endmodule
