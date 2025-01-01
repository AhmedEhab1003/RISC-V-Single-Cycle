module adder(input [31:0] a, b,
             output [31:0] y);
  assign y = a + b;
endmodule

module flip_flop #(parameter WIDTH = 8)
    (input wire clk, reset,
     input wire [WIDTH - 1 :0] d,
     output reg [WIDTH - 1 :0] q);
  always @(posedge clk or posedge reset)
    if (reset) q <= 0;
    else q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
  (input wire [WIDTH - 1 :0] d0, d1,
    input wire s,
    output wire [WIDTH - 1 :0] y);
  assign y = s ? d1 : d0;
endmodule

module mux3 #(parameter WIDTH = 8)
  (input wire [WIDTH - 1 :0] d0, d1, d2,
   input wire [1:0] s,
   output wire [WIDTH - 1 :0] y);
 assign y = s[1] ? d2 : (s[0] ? d1 : d0);
endmodule

module mux3m #(parameter WIDTH = 8)
  (input wire [WIDTH - 1 :0] d0, d1, d2,
   input wire [1:0] s,
   output reg [WIDTH - 1 :0] y);
  always @(*) begin
    case (s)
      2'b00: y = d0;
      2'b01: y = d1;
      2'b11: y = d2;
      default :y= 2'bxx;
        endcase
  end
endmodule
