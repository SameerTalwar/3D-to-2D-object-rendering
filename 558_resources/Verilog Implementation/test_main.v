//`include "main.v"

//`timescale 1ns/1ns
module test_main();
	reg clk, reset, clr_screen;
	reg [6:0] dx_coordinate; //change in x- coordinate
	reg [6:0] dy_coordinate; //change in y- coordinate
	reg [6:0] dz_coordinate; //change in z- coordinate

	reg [6:0] alpha; //change in x-angle (in degrees)
	reg [6:0] beta; //change in y-angle (in degrees)
	reg [6:0] gamma; //change in z-angle (in degrees)
	
	wire vga_clk; 
	wire [2:0]pixel;
	wire Hsync, Vsync, VGA_sync_n, VGA_blank_n;
	//wire transformed
	main uut (clk, reset, clr_screen,
				 dx_coordinate, dy_coordinate, dz_coordinate,
				 alpha, beta, gamma,
				 pixel,
				 Hsync, Vsync);
				 
	
	initial begin

		dx_coordinate = 0; dy_coordinate = 0; dz_coordinate = 0;
		alpha = 0; beta = 0; gamma = 0; 
		reset = 0; clr_screen = 1; 
		
		#20 dx_coordinate = 6'd5;
		#20 dx_coordinate = 6'd0;

		# 20 alpha = 30;
		# 20 alpha = 0;
		# 20 beta = 60;
		# 20 beta = 0;
		# 20 gamma = 90;
		# 20 gamma = 0;
		//# 30 alpha = 30;


		# 10 $display("All combinations checked!");
	end
	
	integer i;
	
	initial begin  
	clk = 0;
		for (i=0;i<=1000;i = i+1) begin
			#10 clk = ~clk;
		end
	end

endmodule 