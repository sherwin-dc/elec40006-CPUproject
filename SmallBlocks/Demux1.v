module Demux1
(
	input In,
	input Sel,
	output Out1, Out2

);

reg O1, O2;
assign Out1 = O1;
assign Out2 = O2;

always @(*) begin
	if(Sel) begin
					O1 = In;
					O2 = 0;
				end
		else begin
					O1 = 0;
					O2 = In;	
				end
	
end

endmodule