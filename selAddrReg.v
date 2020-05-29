module selAddrReg(
	input [15:0] addrIn,
	input regSel,	//0: select addrIn, 1: select address register
	input wren,
	input clock,
	output reg [15:0] addrOut);
	
	reg [15:0] addressReg;
	
	always @(*)
	begin
		if(regSel & !wren) addrOut [15:0] = addressReg [15:0];
		else addrOut [15:0] = addrIn [15:0];
	end
	
	always @(posedge clock)
	begin
		if(wren) addressReg [15:0] = addrIn [15:0];
	end
	
endmodule 