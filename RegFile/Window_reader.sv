module Window_reader
(

input [15:0] window[0:7],
input [2:0] Actual_Rd, Actual_Rs, Actual_Rm,

output reg [15:0] Rd_Out, Rs_Out, Rm_Out
);


always @(*) begin
 Rd_Out = window[Actual_Rd];
 Rs_Out = window[Actual_Rs];
 Rm_Out = window[Actual_Rm];
end

endmodule