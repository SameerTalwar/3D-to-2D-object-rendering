`timescale 1ns/1ns
`include "sine.v"

module sine_tb;

reg [15:0] theta = 0;

initial begin
$dumpfile("sine.vcd");
$dumpvars(0,sine_tb);

# 10 theta = 00;
# 10 theta = 30;
# 10 theta = 90;
# 10 theta = 150;
# 10 theta = 180;
# 10 theta = 200;
# 10 theta = 270;
# 10 theta = 300;
//not working properly for angles less than zero and greater than 360
# 10 theta = 360;
# 50 theta = 390;
# 50 theta = -60;
# 50
# 10 $display("All combinations checked!");
# 10 $finish;
end

//reg clk = 0;
//always #3 clk = !clk;

wire [15:0] value;

sine s1 (theta, value);

initial 
$monitor("At time %t, theta=%h(%d), value = %h (%0d)", 
	$time, theta, theta, value, value);
endmodule
