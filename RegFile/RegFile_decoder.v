module RegFile_decoder
(
input [4:0] opcode,
output reg MoveFP, PushUp

);

always @(*) begin

	PushUp = !opcode[0];

	if(opcode==5'b11100 || opcode==5'b00001)
		MoveFP = 1;
	else
		MoveFP = 0;

end

endmodule