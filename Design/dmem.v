module dmem (input  wire        clk, we,
             input  wire [31:0] a, wd,
             output wire [31:0] rd);

  bit signed [31:0] RAM[255:0];      // 1 KiloByte RAM
  assign rd = RAM[a[9:2]]; 
  always_ff @(posedge clk)
    if (we) RAM[a[9:2]] <= wd;
endmodule
