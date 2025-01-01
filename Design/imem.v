module imem (input  wire [31:0] a,
             output wire [31:0] rd);
  reg [31:0] ROM [255:0];   // 1 Kilobyte ROM
  initial
    $readmemh("ProgramINPUT.txt",ROM);
  assign rd = ROM[a[9:2]]; 
endmodule

