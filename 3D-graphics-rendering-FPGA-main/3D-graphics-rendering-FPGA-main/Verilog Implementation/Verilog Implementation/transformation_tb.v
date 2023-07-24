//testbench

`timescale 1ns/1ns
`include "transformation_block.v"

module transformation_tb;

//reg clk;

reg [16-1:0] alpha = 0; //change in x-angle (in degrees)
reg [16-1:0] beta = 0; //change in y-angle (in degrees)
reg [16-1:0] gamma = 0; //change in z-angle (in degrees)

reg [16-1:0] dx_coordinate = 0; //change in x- coordinate
reg [16-1:0] dy_coordinate = 0; //change in y- coordinate
reg [16-1:0] dz_coordinate = 0; //change in z- coordinate

initial begin
$dumpfile("tb.vcd");
$dumpvars(0,transformation_tb);

#10 dx_coordinate = 16'b1;
#10 dx_coordinate = 16'b0;

# 30 alpha = 30;
# 30 alpha = 0;
//# 30 alpha = 30;


# 10 $display("All combinations checked!");
# 10 $finish;

end

reg clk = 0;
always #3 clk = !clk;

transformation_block t1 (clk,dx_coordinate, dy_coordinate, dz_coordinate, alpha, beta, gamma); 

initial begin
//$monitor("At time %t, alpha=%h(%d))", $time, alpha, alpha);
end

endmodule
