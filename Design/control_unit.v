module control_unit (input  wire [6:0] op,
                     input  wire [2:0] funct3,
                     input  wire       funct7b5,
                     input  wire       opcode_b5,
                     input  wire       Zero,
                     output wire [1:0] ResultSrc,
                     output wire       MemWrite,
                     output wire       ALUSrc,
                     output wire       RegWrite, Jump,
                     output wire [1:0] ImmSrc,
                     output wire [1:0] ALUControl,
                     output wire [1:0] PCSrc2);

  wire [1:0] ALUOp;
  wire Branch;
  wire Jalr;
  
  Main_decoder md (op, ResultSrc, MemWrite, Branch,
                   ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
  ALU_decoder  ad (funct3, funct7b5,opcode_b5, ALUOp, ALUControl);
  
  // jump , beg , bne , jalr logic
  assign PCSrc = (Branch & !Zero & funct3[0]) |
                 (Branch & Zero & !funct3[0]) | Jump;
  assign Jalr  = (op == 7'b1100111) ? 1 : 0 ;
  assign PCSrc2 = {Jalr,PCSrc};
  
endmodule
