module regfile(input  wire        clk, 
               input  wire        we3, 
               input  wire [ 4:0] a1, a2, a3, 
               input  wire [31:0] wd3, 
               output wire [31:0] rd1, rd2);
  
  bit [31:0] register[31:0];  // revert to reg
  
  always @*  register[0] = 32'b0;
  
  always @(posedge clk)
    if (we3 && a3) register[a3] <= wd3;
  assign rd1 = (a1 == 0) ? 32'b0 : register[a1] ;
  assign rd2 = (a2 == 0) ? 32'b0 : register[a2] ; 
  
endmodule
