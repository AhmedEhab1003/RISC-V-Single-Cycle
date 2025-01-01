module top (input  wire        clk, reset,
            input  wire [31:0] Instr ,
            output wire [31:0] PC ,
            output wire [31:0] WriteData, DataAdr,
            output wire [31:0] ReadData,
            output wire        MemWrite);

 //wire [31:0] ReadData;

 // instantiate processor and memories
  riscvsingle RISC_V (clk, reset, Instr, ReadData,
                      MemWrite, PC, DataAdr, WriteData);
  
  dmem dmem (clk, MemWrite, DataAdr, WriteData, ReadData);
endmodule
