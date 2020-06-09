module Compare
(
input R_or_I,
input CMP_or_SUB,
input [2:0] Cond,

input [15:0] rddata, rsdata, N, aluout,
output reg jump

);
reg [15:0] A, B;
reg [15:0] R;
reg WideOr;

// Now do subtraction
adder_to_use_16_bit inst1 (.A(A), .B(~B), .cin(1'b1), .R(R));

always @(*) begin
// initial value of A and B
A = rddata;
WideOr = 1'b0;
        
        // determine whether to use Rs, N
        // If CMP I
        if (R_or_I) begin
            B = N;
        end
        // If CMP R
        else begin
            B = rsdata;
        end


WideOr = R[15] | R[14] | R[13] | R[12] | R[11] | R[10] | R[9] | R[8] | R[7] | R[6] | R[5] | R[4] | R[3] | R[2] | R[1] | R[0]; // WideOr = 1 if R !=0

case(Cond)
    3'b000 : jump = !WideOr; // Rd == Rs/N
    3'b001 : jump = WideOr; // Rd != Rs/N
    3'b010 : jump = WideOr & !(R[15]); // Rd > Rs/N  // Checks that R != 0 and R !< 0
    3'b011 : jump = R[15]; // Rd < Rs/N
    3'b100 : jump = !(rddata[15] | rddata[14] | rddata[13] | rddata[12] | rddata[11] | rddata[10] | rddata[9] | rddata[8] | rddata[7] | rddata[6] | rddata[5] | rddata[4] | rddata[3] | rddata[2] | rddata[1] | rddata[0]);
    3'b101 : jump = rddata[15]; // Rd < 0
    3'b110 : jump = rddata[15] & rddata[14] & rddata[13] & rddata[12] & rddata[11] & rddata[10] & rddata[9] &  rddata[8] &  rddata[7] &  rddata[6] &  rddata[5] &  rddata[4] &  rddata[3] &  rddata[2] &  rddata[1] &  rddata[0]; 
    default : jump = 1'b0;

endcase
//if it is SUB
if (CMP_or_SUB)
   jump = !(aluout[15] | aluout[14] | aluout[13] | aluout[12] | aluout[11] | aluout[10] | aluout[9] |  aluout[8] |  aluout[7] |  aluout[6] |  aluout[5] |  aluout[4] |  aluout[3] |  aluout[2] |  aluout[1] |  aluout[0]); 

end 
endmodule