module CompBlock
(
	input clk,
	input [15:0] vertices_1 ,
	input [15:0] vertices_2,
	input [15:0] vertices_3, 
	input [15:0] cos_alpha, sin_alpha,
	input [15:0] cos_beta,  sin_beta,
	input [15:0] cos_gamma, sin_gamma,
	input [15:0] dx, dy, dz,
	
	output [15:0] vertices_out 
);

	reg [15:0] vert1 ;
	reg [15:0] vert2 ;
	reg [15:0] vert3 ;
	reg [15:0] vert4 ;
	reg [15:0] vert ; 
	integer i = 0;
	always @(posedge clk) begin
		vert1 = vertices_1 * cos_alpha * cos_gamma;
		vert2 = vertices_2 * sin_alpha * sin_gamma;
		vert3 = vertices_3 * cos_beta  * sin_beta;
		vert4 = dx + dy + dz;
		vert  = vert1 + vert2 + vert3 + vert4;
	end
	
	assign vertices_out = vert;
	//assign vertices_out[1] = vert[1];
	//assign vertices_out[2] = vert[2];

endmodule
