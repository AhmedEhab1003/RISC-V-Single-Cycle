interface riscv_if (input logic clk) ;

  logic        reset     ; 
  logic [31:0] Instr     ;
  logic [31:0] PC        ;
  logic [31:0] WriteData ;
  logic [31:0] DataAdr   ;
  logic [31:0] ReadData  ;
  logic        MemWrite  ;

endinterface 
