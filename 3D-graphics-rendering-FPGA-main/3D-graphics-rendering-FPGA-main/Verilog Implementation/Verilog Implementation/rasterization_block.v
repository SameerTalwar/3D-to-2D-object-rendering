`timescale 1ns/1ns
//`include "sine.v"
//`include "cosine.v"
//`include "rasterize_points.v"
//`include "mul_2.v"
//`include "mul_3.v"

module rasterization_block (
	input clk,
	input signed [32-1:0] v1,
	input signed [32-1:0] v2 ,
	input signed [32-1:0] v3 

);

//assume the coordinates are sorted on y-axis in pre-processing step done in python

reg [16-1:0] vert1 [2-1:0];
reg [16-1:0] vert2 [2-1:0];
reg [16-1:0] vert3 [2-1:0];
reg [16-1:0] helper_point [2-1:0];
integer dummy_rast;
reg unsigned en;


rasterize_points rp (en,clk, vert1[0], vert1[1], vert2[0], vert2[1], helper_point[0], helper_point[1]);

always@(clk) begin


vert1[0] = v1[15:0]; //x1
vert1[1] = v1[31:16]; //y1

vert2[0] = v2[15:0]; //x2
vert2[1] = v2[31:16]; //y2

vert3[0] = v3[15:0]; //x3
vert3[1] = v3[31:16]; //y3

//-------------------initialize input port values to check
//vert1[0] = 16'd5;
//vert1[1] = 16'd1;
//vert2[0] = 16'd14;
//vert2[1] = 16'd8;
//vert3[0] = 16'd10;
//vert3[1] = 16'd15;
//
//helper_point[0]= 16'b0;
//helper_point[1]= 16'b0;
//--------------------------------------------------

en = 0;

// Check for triangles with horizontal edge
if (vert2[1] == vert3[1]) begin
	//Bottom is horizontal

	//rasterize flat triangle
end

else if (vert1[1] == vert2[1]) begin
	// Top is horizontal
	//rasterize flat triangle
end

else begin
 	// General triangle.
 	// We'll split this into two triangles with horizontal edges and process them separately.
 	// Find the additional vertex that splits the triangle.
	
	helper_point[0] = vert1[0] + ((vert2[1] - vert1[1])* (vert3[0] - vert1[0]))/(vert3[1] - vert1[1]) ;
	helper_point[1] = vert2[1];

	//rasterize top flat tri
	en = 1;
	//rasterize bottom flat tri 
	$display("code3");

end

$display("helper point: (%d, %d)", helper_point[0],helper_point[1]);
end
endmodule





