
module riscvsingle (input  wire        clk, reset,
                    input  wire [31:0] Instr,
                    input  wire [31:0] ReadData,
                    output wire        MemWrite,
                    output wire [31:0] PC,
                    output wire [31:0] ALUResult, WriteData);
  
  wire ALUSrc, RegWrite, Jump, Zero;
  wire [1:0] ResultSrc, ImmSrc;
  wire [1:0] ALUControl;
  wire [1:0] PCSrc2;
  
  control_unit c(.op            (Instr[6:0]),
                 .funct3        (Instr[14:12]),
                 .funct7b5      (Instr[30]),
                 .Zero          (Zero),
                 .ResultSrc     (ResultSrc),
                 .MemWrite      (MemWrite),
                 .ALUSrc        (ALUSrc),
                 .RegWrite      (RegWrite),
                 .Jump          (Jump),
                 .ImmSrc        (ImmSrc),
                 .ALUControl    (ALUControl),
                 .PCSrc2        (PCSrc2));
                 
  
  datapath dp  (.clk            (clk),
                .reset          (reset),
                .ResultSrc      (ResultSrc),
                .ALUSrc         (ALUSrc),
                .RegWrite       (RegWrite),
                .ImmSrc         (ImmSrc),
                .ALUControl     (ALUControl),
                .Instr          (Instr),
                .Jump           (Jump),
                .PCSrc2         (PCSrc2),
                .ReadData       (ReadData),
                .PC             (PC),
                .Zero           (Zero),
                .ALUResult      (ALUResult),
                .WriteData      (WriteData));
endmodule
