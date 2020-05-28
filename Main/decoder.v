module decoder
(
	input [15:0] instr, N, pc, rddata, rsdata,
	input jump,
	
	output reg [15:0] instr_addr1, instr_addr2, data_addr1, data_addr2, new_pc,
	output reg [2:0] giantmux_sel,
	output instr_wen2, data_wen1, data_wen2, rd_wen, rs_wen, move_fp, push_up, cnt_en, pc_sload, rsmux_sel
);

wire [10:0] i = {instr[15:11], instr[4:0], jump}; // wire for inputs
reg [9:0] o;

assign {instr_wen2, data_wen1, data_wen2, rd_wen, rs_wen, move_fp, push_up, cnt_en, pc_sload, rsmux_sel} = o;

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
			o = 10'b000000010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end

		11'b00001xxxxxx: // CALL
		begin 
			o = 10'b000101001x;
			giantmux_sel = 3'b001; // PC
			instr_addr1 = N;
			instr_addr2 = N + 1'd1;
			new_pc = N + 1'd1;
		end

		11'b11100xxxxxx: // RTN
		begin
			o = 10'b000001101x;
			instr_addr1 = rddata;
			instr_addr2 = rddata + 1'd1;
			new_pc = rddata + 1'd1;
		end

		11'b11000xxxxxx: // LSL
		begin
			o = 10'b000100010x;
			giantmux_sel = 3'b100; // aluout
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end 

		11'b11010xxxxxx: // LSR
		begin
			o = 10'b000100010x;
			giantmux_sel = 3'b100; // aluout
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end 

		11'b0001xxxxxx0: // failed CMP 
		begin 
			o = 10'b000000010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end

		11'b0001xxxxxx1: // CMP passed 
		begin
			o = 10'b000000001x;
			instr_addr1 = pc + instr[1:0]; // is this allowed? or will this work?
			instr_addr2 = pc + instr[1:0] + 1'd1; 
			new_pc = pc + instr[1:0] + 1'd1;
		end 

		11'b00100xxxxxx: // JMP R
		begin
			o = 10'b000000001x;
			instr_addr1 = rddata;
			instr_addr2 = rddata + 1'd1;
			new_pc = rddata + 1'd1;
		end 

		11'b00101xxxxxx: // JMP I
		begin
			o = 10'b000000001x;
			instr_addr1 = N;
			instr_addr2 = N + 1'd1;
			new_pc = N + 1'd1;
		end 

		11'b01000xxxxxx: // ADD R
		begin
			o = 10'b000100010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01001xxxxxx: // ADD I
		begin
			o = 10'b000100001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01010xxx0xx: // SUB R, no jump cond 
		begin 
			o = 10'b000100010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01010xxx1x0: // SUB R, jump cond failed
		begin 
			o = 10'b000100010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b100; // aluout
		end

		11'b01010xxx101: // SUB R, jump passed, next instruction R
		begin
			o = 10'b000100001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01010xxx111: // SUB R, jump passed, next instruction I
		begin 
			o = 10'b000100001x;
			instr_addr1 = pc + 2'd2;
			instr_addr2 = pc + 2'd3;
			new_pc = pc + 2'd3;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01011xxx0xx: // SUB I, no jump cond
		begin
			o = 10'b000100001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01011xxx1x0: // SUB I, jump cond failed
		begin
			o = 10'b000100001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01011xxx101: // SUB I, jump passed, next instruction R
		begin 
			o = 10'b000100001x;
			instr_addr1 = pc + 2'd2;
			instr_addr2 = pc + 2'd3;
			new_pc = pc + 2'd3;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b01011xxx111: // SUB I, jump passed, next instruction I
		begin
			o = 10'b000100001x;
			instr_addr1 = pc + 2'd3;
			instr_addr2 = pc + 3'd4;
			new_pc = pc + 3'd4;
			giantmux_sel = 3'b100; // aluout
		end 

		11'b0110xxxxxx: // MAS R
		begin 
			o = 10'b000100010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b101; // masout
		end 

		11'b01101xxxxxx: // MAS I
		begin 
			o = 10'b000100001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			giantmux_sel = 3'b101; // masout
		end 

		11'b01110xxxxxx: // MOV R
		begin 
			o = 10'b000100010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b000; // rsdata
		end

		11'b01111xxxxxx: // MOV I
		begin 
			o = 10'b000100001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			giantmux_sel = 3'b010; // N (instr_out2)
		end

		11'b11111xxxxxx: // STP
		begin
			o = 10'b000000000x;
			instr_addr1 = pc - 1'd1;
			instr_addr2 = pc;
		end

		11'b10110001xxx: // SET R, data, set B only
		begin 
			o = 10'b000000010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			data_addr2 = rsdata;
		end

		11'b10110010xxx: // SET R, data, set A only
		begin 
			o = 10'b000000010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			data_addr1 = rddata;
		end

		11'b10110011xxx: // SET R, data, set A & B
		begin 
			o = 10'b000000010x;
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			data_addr1 = rddata;
			data_addr2 = rsdata;
		end

		11'b101101x1xxx: // SET R, instruction, set B only
		begin 
			o = 10'b000000010x;
			instr_addr1 = pc;
			instr_addr2 = rsdata;
		end

		11'b1011100100x: // SET I, data, set B, no offset
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr2 = rsdata;
		end

		11'b1011101000x: // SET I, data, set A, no offset
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = N;
		end

		11'b1011101100x: // SET I, data, set A & B, no offset
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = N;
			data_addr2 = rsdata;
		end

		11'b10111001x1x: // SET I, data, set B, offset
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr2 = rsdata + N;
		end

		11'b101110101xx: // SET I, data, set A, offset
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
		end

		11'b1011101110x: // SET I, data, set A & B, offset A
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
			data_addr2 = rsdata;
		end

		11'b1011101101x: // SET I, data, set A & B, offset B
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata;
			data_addr2 = rsdata + N;
		end

		11'b1011101111x: // SET I, data, set A & B, offset both
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = pc + 2'd2;
			new_pc = pc + 2'd2;
			data_addr1 = rddata + N;
			data_addr2 = rsdata + N;
		end

		11'b101111x100x: // SET I, instruction, set B, no offset
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = rsdata;
			new_pc = pc + 2'd2;
		end

		11'b101111x1x1x: // SET I, instruction, set B, offset
		begin 
			o = 10'b000000001x;
			instr_addr1 = pc + 1'd1;
			instr_addr2 = rsdata + N;
			new_pc = pc + 2'd2;
		end

		11'b100000xxxxx: // PLD A and/or B, data 
		begin 
			o = {3'b000, instr[3], instr[2], 4'b00100};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b110; // data_out1
		end

		11'b100001xxxxx: // PLD A and/or B, instruction
		begin 
			o = {3'b000, instr[3], instr[2], 4'b00101};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
			giantmux_sel = 3'b011; // instruction_out1
		end
		
		11'b100100xxxxx: // PST A and/or B, data
		begin 
			o = {1'b0, instr[3], instr[2], 6'b000010x};
			instr_addr1 = pc;
			instr_addr2 = pc + 1'd1;
		end

		11'b100101xxxxx: // PST A and/or B, instruction
		begin 
			o = {10'b100000010x};
			instr_addr1 = pc;
		end

		default: // current default is STP
		begin
			o = 10'b000000000x;
			instr_addr1 = pc - 1'b1;
			instr_addr2 = pc;
		end

		endcase	
	end

endmodule
