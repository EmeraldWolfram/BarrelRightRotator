// Topic: 8-bit Barrel Shifter

module barrel
 #(parameter data_size = 8)    // data_size : 8-bit as default
  (input clk, reset, Load,
   input [log2(data_size)-1:0] sel,
   input [data_size-1:0] data_in,
   output reg [data_size-1:0] data_out
   );

//Parameterized data_size using "log2" function
function integer log2;
input [31:0] size;
for (log2 = 0; size > 1; log2 = log2 + 1)
   size = size >> 1;
endfunction

//Declare intermediate values of barrel shifter
wire [data_size-1:0] brl_in;
reg [data_size-1:0] brl_out; //[data_size-1:0]

//Multiplexing data_in or feedback from data_out
assign brl_in = Load? data_in : data_out;

always @ (posedge clk)
if (reset)
  data_out <= 8'd0;
else
  data_out <= brl_out;

always @ (sel, brl_in)
case (sel)
3'd0: brl_out = brl_in;
3'd1: brl_out = {brl_in[0], brl_in[7:1]};
3'd2: brl_out = {brl_in[1:0], brl_in[7:2]};
3'd3: brl_out = {brl_in[2:0], brl_in[7:3]};
3'd4: brl_out = {brl_in[3:0], brl_in[7:4]};
3'd5: brl_out = {brl_in[4:0], brl_in[7:5]};
3'd6: brl_out = {brl_in[5:0], brl_in[7:6]};
3'd7: brl_out = {brl_in[6:0], brl_in[7]};
default: brl_out = brl_in;
endcase

endmodule



