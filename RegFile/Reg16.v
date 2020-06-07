module Reg16
(
input [3:0] Rd_Addr, Rs_Addr, Rm_Addr,
input Rd_Wen, Rs_Wen,
input [15:0] Rd_Data, Rs_Data,

output [15:0] Rd_Out, Rs_Out, Rm_Out,

input Clock

);
// the 128 registers
reg [15:0] R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15;
reg [15:0] RdOut, RsOut, RmOut;
assign Rd_Out = RdOut;
assign Rs_Out = RsOut;
assign Rm_Out = RmOut;




// To write data on positive edge of clock
always @(posedge Clock) begin
    if(Rd_Wen)
        case(Rd_Addr)
            4'd0 : R0 <= Rd_Data;
            4'd1 : R1 <= Rd_Data;
            4'd2 : R2 <= Rd_Data;
            4'd3 : R3 <= Rd_Data;
            4'd4 : R4 <= Rd_Data;
            4'd5 : R5 <= Rd_Data;
            4'd6 : R6 <= Rd_Data;
            4'd7 : R7 <= Rd_Data;
            4'd8 : R8 <= Rd_Data;
            4'd9 : R9 <= Rd_Data;
            4'd10 : R10 <= Rd_Data;
            4'd11 : R11 <= Rd_Data;
            4'd12 : R12 <= Rd_Data;
            4'd13 : R13 <= Rd_Data;
            4'd14 : R14 <= Rd_Data;
            4'd15 : R15 <= Rd_Data;
        endcase
    
    if(Rs_Wen)
        case(Rs_Addr)
            4'd0 : R0 <= Rs_Data;
            4'd1 : R1 <= Rs_Data;
            4'd2 : R2 <= Rs_Data;
            4'd3 : R3 <= Rs_Data;
            4'd4 : R4 <= Rs_Data;
            4'd5 : R5 <= Rs_Data;
            4'd6 : R6 <= Rs_Data;
            4'd7 : R7 <= Rs_Data;
            4'd8 : R8 <= Rs_Data;
            4'd9 : R9 <= Rs_Data;
            4'd10 : R10 <= Rs_Data;
            4'd11 : R11 <= Rs_Data;
            4'd12 : R12 <= Rs_Data;
            4'd13 : R13 <= Rs_Data;
            4'd14 : R14 <= Rs_Data;
            4'd15 : R15 <= Rs_Data;
        endcase
    
end

// To read data without clock
always @(posedge Clock) begin
    case(Rd_Addr)
        4'd0 : RdOut = R0;
        4'd1 : RdOut = R1;
        4'd2 : RdOut = R2;
        4'd3 : RdOut = R3;
        4'd4 : RdOut = R4;
        4'd5 : RdOut = R5;
        4'd6 : RdOut = R6;
        4'd7 : RdOut = R7;
        4'd8 : RdOut = R8;
        4'd9 : RdOut = R9;
        4'd10 : RdOut = R10;
        4'd11 : RdOut = R11;
        4'd12 : RdOut = R12;
        4'd13 : RdOut = R13;
        4'd14 : RdOut = R14;
        4'd15 : RdOut = R15;
    endcase

    case(Rs_Addr)
        4'd0 : RsOut = R0;
        4'd1 : RsOut = R1;
        4'd2 : RsOut = R2;
        4'd3 : RsOut = R3;
        4'd4 : RsOut = R4;
        4'd5 : RsOut = R5;
        4'd6 : RsOut = R6;
        4'd7 : RsOut = R7;
        4'd8 : RsOut = R8;
        4'd9 : RsOut = R9;
        4'd10 : RsOut = R10;
        4'd11 : RsOut = R11;
        4'd12 : RsOut = R12;
        4'd13 : RsOut = R13;
        4'd14 : RsOut = R14;
        4'd15 : RsOut = R15;
    endcase

    case(Rm_Addr)
        4'd0 : RmOut = R0;
        4'd1 : RmOut = R1;
        4'd2 : RmOut = R2;
        4'd3 : RmOut = R3;
        4'd4 : RmOut = R4;
        4'd5 : RmOut = R5;
        4'd6 : RmOut = R6;
        4'd7 : RmOut = R7;
        4'd8 : RmOut = R8;
        4'd9 : RmOut = R9;
        4'd10 : RmOut = R10;
        4'd11 : RmOut = R11;
        4'd12 : RmOut = R12;
        4'd13 : RmOut = R13;
        4'd14 : RmOut = R14;
        4'd15 : RmOut = R15;
    endcase
end
endmodule