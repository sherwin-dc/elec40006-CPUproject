module new_Reg16
(
input [3:0] Rd_Addr, Rs_Addr, Rm_Addr, New_FP,
input Rd_Wen, Rs_Wen, FP_move, FP_push_up,
input [15:0] Rd_Data, Rs_Data,
input [2:0] Actual_Rd, Actual_Rs, Actual_Rm,


output reg [15:0] Rd_Out, Rs_Out, Rm_Out,
//output reg [15:0] ReadReg[0:7],
input Clock

);
// the 128 registers
reg [15:0] Registers[0:15];
reg [15:0] ReadReg[0:7];

//reg [15:0] RdOut, RsOut, RmOut;
reg [2:0] MoveFP_Reg_addr;

integer i;

// To read data without clock
 always @(*) begin
  Rd_Out = ReadReg[Actual_Rd];
  Rs_Out = ReadReg[Actual_Rs];
  Rm_Out = ReadReg[Actual_Rm];
 end 



// To write data on positive edge of clock
// Whenever data is written, also write it to read register
always @(posedge Clock) begin
    if(Rd_Wen)
        Registers[Rd_Addr] <= Rd_Data;
    
    if(Rs_Wen)
        Registers[Rs_Addr] <= Rs_Data;
    
    // If FP is being changed - for CALL and RTN - (to +/- I), write Rd to read register -/+ I
    if(FP_move) begin
        if(Rd_Wen) begin
            // If Push_Up is 1, then need to add to ReadReg Addr
            if(FP_push_up) begin
                if(Actual_Rd[2:0] + Actual_Rs[2:0] <= 4'd7) begin
                    MoveFP_Reg_addr[2:0] = Actual_Rd[2:0] + Actual_Rs[2:0];
                    ReadReg[MoveFP_Reg_addr] <= Rd_Data;
                    // send register to output on posedge clcok
                    //window_out[MoveFP_Reg_addr] <= Rd_Data;
                end
            end else begin
                if(Actual_Rd[2:0] >= Actual_Rs[2:0]) begin
                    MoveFP_Reg_addr[2:0] = Actual_Rd[2:0] - Actual_Rs[2:0];
                    ReadReg[MoveFP_Reg_addr] <= Rd_Data;
                    // send register to output on posedge clock
                    //window_out[MoveFP_Reg_addr] <= Rd_Data;
                end
            end

            // Now copy all other addreses to ReadReg
            // This is for Call where one address was written to
            for(i=0 ; i<8 ; i=i+1) begin
                if(i != MoveFP_Reg_addr)
                    ReadReg[i] <= Registers[New_FP + i];
            end


        end else begin
            // Now copy all addreses to ReadReg
            // This is for RTN where no address was written to
            for(i=0 ; i<8 ; i=i+1) begin
                    ReadReg[i] <= Registers[New_FP + i];
            end
        end

        

        
    end else begin // If FP is not being changed, write Rd and Rs data to ReadReg
        if(Rd_Wen)
            ReadReg[Actual_Rd] <= Rd_Data;
    
        if(Rs_Wen)
            ReadReg[Actual_Rs] <= Rs_Data;
    end

end

 
 
endmodule