module new_Reg128
(
input [3:0] Rd_Addr, Rs_Addr, Rm_Addr,
input Rd_Wen, Rs_Wen,
input [15:0] Rd_Data, Rs_Data,

output [15:0] Rd_Out, Rs_Out, Rm_Out,

input Clock

);
// the 128 registers
reg [15:0] Registers[0:128];
reg [15:0] RdOut, RsOut, RmOut;



// To read data without clock
assign Rd_Out = Registers[Rd_Addr];
assign Rs_Out = Registers[Rs_Addr];
assign Rm_Out = Registers[Rm_Addr];

// To write data on positive edge of clock
always @(posedge Clock) begin
    if(Rd_Wen)
        Registers[Rd_Addr] <= Rd_Data;
    
    if(Rs_Wen)
        Registers[Rs_Addr] <= Rs_Data;
    
end

endmodule