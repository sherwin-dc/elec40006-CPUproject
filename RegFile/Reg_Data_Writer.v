module Data_writer
(
	input [15:0] In1, In2, // Rd and Rs In
	input A1, A2, // Address Rd and Rs
	input En1, En2, // Rd and Rs Wr En
	output [15:0] Out1, Out2, // Outputs that go to resgisters 1 and 2 respectively
	output EnOut1, EnOut2 // Outputs that go to enable registers 1 and 2 respectively

);

reg [15:0] O1, O2;
reg EO1, EO2;

assign Out1 = O1;
assign Out2 = O2;

assign EnOut1 = EO1;
assign EnOut2 = EO2;



always @(*) begin

	//default is 0
	O1 = 16'h0000;
	O2 = 16'h0000;
	EO1 = 0;
	EO2 = 0;


	//if Rs WrEn is 1
	if(En2) begin
		if(A2) 	begin
						O2 = In2;
						EO2 = 1;
					end
		else 		begin
						O1 = In2;
						EO1 = 1;
					end
	end

	// If Rd and Rs point to the same address but with differnt data, proritize data on Rd
	if(En1) begin
		if(A1) 	begin
						O2 = In1;
						EO2 = 1;
					end
		else 		begin
						O1 = In1;
						EO1 = 1;
					end
	end
end

endmodule