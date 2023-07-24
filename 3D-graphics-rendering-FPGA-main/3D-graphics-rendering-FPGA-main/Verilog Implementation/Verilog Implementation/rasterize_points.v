module rasterize_points
(input clk,
input unsigned en,
input [16-1:0] vert1_xi,
input [16-1:0] vert1_yi,
input [16-1:0] vert2_xi,
input [16-1:0] vert2_yi,
input [16-1:0] vert3_xi,
input [16-1:0] vert3_yi);

reg [16-1:0] vert1_x, vert1_y, vert2_x, vert2_y, vert3_x, vert3_y;
reg unsigned enable;
integer ydir, invslope1, invslope2;
integer curx1, curx2, scanlineY;
reg [16-1:0] temp;

always@(clk)begin

//$display("i am tired");
vert1_x = vert1_xi;
vert2_x = vert2_xi;
vert3_x = vert3_xi;
vert1_y = vert1_yi;
vert2_y = vert2_yi;
vert3_y = vert3_yi;
enable = en;

//-------------------------test initialization (comment me)
//enable= 1;
//vert1_x = 16'd500;
//vert1_y = 16'd100;
//vert2_x = 16'd1400;
//vert2_y = 16'd800;
//vert3_x = 16'd800;
//vert3_y = 16'd800;
//---------------------------------------------------------


if (enable == 1) begin

// Is the bottom or the top edge horizontal?
	ydir = (vert2_y - vert1_y) >= 0? 1 : -1;
	$display("ydir: ", ydir);

// Make sure that the horizontal edge is left-right oriented
	if(vert2_x > vert3_x) begin
	temp = vert2_x;
	vert2_x = vert3_x;
	vert3_x = temp;
	end
	$display("vert1: (%d, %d), vert2: (%d, %d), vert3: (%d, %d)", vert1_x, vert1_y, vert2_x, vert2_y, vert3_x, vert3_y);

// Find the inverse slope (dx/dy) for the two non-horizontal edges
	invslope1 = (ydir * 100*(vert2_x - vert1_x))/(vert2_y - vert1_y);
	invslope2 = (ydir * 100*(vert3_x - vert1_x))/(vert3_y - vert1_y);
	$display("invslope1: %d, invslope2: %d", invslope1, invslope2);

// Initialize the first scan line, which is one y-step below or above the first vertex
	curx1 = (vert1_x + invslope1);
	curx2 = (vert1_x + invslope2);
	$display("curx1: %d, curx2: %d",curx1,curx2);

// Step vertically. Don't include the first row, because that row only
// contains the first vertex and we don't want to return the vertices
	for (scanlineY = vert1_y + ydir*100; scanlineY < vert2_y; scanlineY=scanlineY+100) begin
	curx1 = (curx1 + invslope1);
	curx2 = (curx2 + invslope2);
	$display("curx1: %d, curx2: %d",curx1,curx2);
	end
//	$display("i am working");
end
end

endmodule
