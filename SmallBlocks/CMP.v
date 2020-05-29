module CMP
(
	input [15:0] rddata, rsdata, N, aluout,
	input [4:0] instruction,
	
	output jump

);

wire [4:0] cond = instruction; 

reg result;

assign jump = result;

always @(*) begin
	
		casex (cond)
			5'b00000 : result = rddata == rsdata ? 1'b1 : 1'b0;
			5'b00001 : result = rddata != rsdata ? 1'b1 : 1'b0;
			5'b00010 : result = rddata > rsdata ? 1'b1 : 1'b0; // doesnt take into account negative numbers
			5'b00011 : result = rddata < rsdata ? 1'b1 : 1'b0;		
			5'b00100 : result = rddata == 0 ? 1'b1 : 1'b0;		
			5'b00101 : result = rddata[15] == 1 ? 1'b1 : 1'b0;
			5'b00110 : result = rddata == 16'hFFFF ? 1'b1 : 1'b0;
			
			5'b01000 : result = rddata == N ? 1'b1 : 1'b0;
			5'b01001 : result = rddata != N ? 1'b1 : 1'b0;
			5'b01010 : result = rddata > N ? 1'b1 : 1'b0;
			5'b01011 : result = rddata < N ? 1'b1 : 1'b0;
			
			5'b1xxxx : result = aluout == 0 ? 1'b1 : 1'b0; // for SUB cond jump

			default : result = 0;
		endcase
end

endmodule