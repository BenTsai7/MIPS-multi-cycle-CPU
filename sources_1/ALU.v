module ALU(
    input [2:0] ALUOp,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] result,
    output zero,
    output sign
    );
 
    assign zero = (result==0)?1:0;
    assign sign = result[31] == 0 ? 0 : 1;
    always @( ALUOp or A or B ) begin
        case (ALUOp)
          3'b000 : result = A + B;
          3'b001 : result = A - B;
          3'b010 : result = (A < B) ? 1 : 0; 
          3'b011 : result = (A < B && A[31] == B[31] || 
                                          A[31] == 1 && B[31] == 0) ? 1:0;
          3'b100 : result = B << A;
          3'b101 : result = A | B;
          3'b110 : result = A & B; 
          3'b111 : result = A ^ B;
         default : result = 32'h00000000;
         endcase
     end
endmodule