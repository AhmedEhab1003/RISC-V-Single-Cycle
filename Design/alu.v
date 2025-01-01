module alu(input  wire [31:0] a, b,
           input  wire [1:0]  alucontrol,
           output reg  [31:0] result,
           output wire        zero);

  wire [31:0] condinvb, sum;
  assign condinvb = alucontrol[0] ? ~b : b;   // ones's comp if sub
  assign sum = a + condinvb + alucontrol[0];  // two's comp if sub

  always @(*)
    case (alucontrol)
      2'b00: result = sum; // add
      2'b01: result = sum; // subtract
      2'b10: result = a & b; // and
      2'b11: result = a | b; // or
      default: result = 32'bx;
 endcase
 assign zero = (result == 32'b0);
endmodule
