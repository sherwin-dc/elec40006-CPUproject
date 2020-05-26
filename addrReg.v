module addrReg(
	input clock,
	input [15:0] addrInA,
	output reg [15:0] addrOutA,
	input wrenA,
	input [15:0] addrInB,
	output reg [15:0] addrOutB,
	input wrenB);
	
	reg [15:0] ffA;
	reg [15:0] ffB;
	
	always @(*)
	begin
		if(wrenA) addrOutA [15:0] = addrInA [15:0];
		else addrOutA [15:0] = ffA [15:0];
		
		if(wrenB) addrOutB [15:0] = addrInB [15:0];
		else addrOutB [15:0] = ffB [15:0];
	end	
	
	always @(posedge clock)
	begin
		if(wrenA) ffA [15:0] = addrInA [15:0];
		
		if(wrenB) ffB [15:0] = addrInB [15:0];
	end

	
endmodule 