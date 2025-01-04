module datapath(input wire         clk, reset,
                input wire  [1:0]  ResultSrc,
                input wire 	       ALUSrc,
                input wire         RegWrite,
                input wire  [1:0]  ImmSrc,
                input wire  [1:0]  ALUControl,
                input wire  [31:0] Instr,
                input wire  [31:0] ReadData,
                input wire  [1:0]  PCSrc2,
                input wire         Jump,
                output wire [31:0] ALUResult, WriteData,
                output wire        Zero,
                output wire [31:0] PC);

  wire [31:0] PCNext, PCPlus4, PCTarget;
  wire [31:0] ImmExt;
  wire [31:0] SrcA, SrcB;
  wire [31:0] Result;
  wire [31:0] WE3sel;
  
 // next PC 
  flip_flop #(32) pcreg(clk, reset, PCNext, PC);
  adder pcadd4(PC, 32'd4, PCPlus4);
  adder pcaddbranch(PC, ImmExt, PCTarget);
  mux3m #(32) pcmux(PCPlus4, PCTarget, Result, PCSrc2, PCNext);
  mux2  #(32) jmux (Result, PCPlus4, Jump , WE3sel ); 
  
 // register file 
  regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20],Instr[11:7],
             WE3sel,SrcA, WriteData);
  // Extend
  extend ext(Instr[31:7], ImmSrc, ImmExt);
  
 // ALU 
  mux2 #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
  alu alu(SrcA, SrcB, ALUControl, ALUResult, Zero);
  mux3 #(32) resultmux(ALUResult, ReadData, PCPlus4,
                       ResultSrc, Result);
endmodule
