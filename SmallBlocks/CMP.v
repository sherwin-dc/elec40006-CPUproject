module CMP
(
	input [15:0] rddata, rsdata, N,
	input [3:0] instruction,
	
	output jump

);

wire [3:0] cond = instruction; 

reg result;

assign jump = result;

always @(*) begin
	
		casex (cond)
			4'b0000 : result = rddata == rsdata ? 1'b1 : 1'b0;
			4'b0001 : result = rddata != rsdata ? 1'b1 : 1'b0;
			4'b0010 : result = rddata > rsdata ? 1'b1 : 1'b0; // doesnt take into account negative numbers
			4'b0011 : result = rddata < rsdata ? 1'b1 : 1'b0;		
			4'b0100 : result = rddata == 0 ? 1'b1 : 1'b0;		
			4'b0101 : result = rddata[15] == 1 ? 1'b1 : 1'b0;
			4'b0110 : result = rddata == 16'hFFFF ? 1'b1 : 1'b0;
			
			4'b1000 : result = rddata == N ? 1'b1 : 1'b0;
			4'b1001 : result = rddata != N ? 1'b1 : 1'b0;
			4'b1010 : result = rddata > N ? 1'b1 : 1'b0;
			4'b1011 : result = rddata < N ? 1'b1 : 1'b0;
			
			//5'b1xxxx : result = aluout == 0 ? 1'b1 : 1'b0; // for SUB cond jump

			default : result = 0;
		endcase
end

endmodule