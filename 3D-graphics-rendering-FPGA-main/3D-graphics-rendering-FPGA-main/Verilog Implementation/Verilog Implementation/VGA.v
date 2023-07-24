module VGA ( clk, reset, clr_screen, pixel_color, 
				 start_rd, vga_clk, red, green, blue, 
				 Hsync, Vsync, VGA_sync_n, VGA_blank_n );
	
	input clk, clr_screen, reset;
	input pixel_color;
	output start_rd;
	output vga_clk, Hsync, Vsync, VGA_blank_n, VGA_sync_n;
	output [2:0] red, green;
	output [1:0] blue;
	
	parameter hsyncro = 96, hbporch = 48, hactive = 640, hfporch = 16;
	parameter htotal  = hsyncro + hbporch + hactive + hfporch;
	parameter vsyncro = 2,  vbporch = 31, vactive = 480, vfporch = 11;
	parameter vtotal  = vsyncro + vbporch + vactive + vfporch;
	
	reg [9:0] hcount = 0;
   reg [9:0] vcount = 0;
	reg st_count, st_show;
	
	wire Line_end, Field_end; 
	reg [7:0] RGV;
	//wire [18:0] write_frame_address, read_frame_address;
	
	
	always @(posedge clk) begin
		if ( reset )         hcount <= 0;
		else if ( Line_end ) hcount <= 0;
		else				 hcount <= hcount + 1;
	end
	
	always @(posedge clk) begin
		if ( reset ) 		   vcount <= 0;
		else if ( Line_end  ) begin
			if ( ~ Field_end ) vcount <= vcount + 1;
			else 			   vcount <= 0;
		end
	end
	
	assign Line_end  = hcount == htotal - 1;
	assign Field_end = vcount == vtotal - 1;
	
	assign Hsync = (hcount >= hactive + hfporch) && (hcount < htotal - hbporch);
	assign Vsync = (vcount >= vactive + vfporch) && (vcount < vtotal - vbporch);
	
	//assign write_frame_address = x_ip + 20*y_ip;
	//assign read_frame_address  = (hcount - 310) + 20*(vcount - 230);
	
	assign start_rd = (hcount >= 310) && (hcount < hactive - 330) && (vcount >= 230) && (vcount < vactive - 250);
	
	/*always @(posedge clk) begin
		if ( start_wr ) framebuffer[write_frame_address] <= pixel_color;
		if ( start_rd ) RGV <= framebuffer[read_frame_address];
	end*/
	
	assign vga_clk = hcount[0];
	assign VGA_blank_n = ~start_rd;
	assign VGA_sync_n = 1;
	
	always @(posedge clk) begin
		if ( start_rd & pixel_color) begin
			RGV = 8'b11110001;
		end
		else begin 
			RGV = 8'b00000000;
		end
	end
	
	assign red   = RGV[7:5];
	assign green = RGV[4:2];
	assign blue  = RGV[1:0];
endmodule