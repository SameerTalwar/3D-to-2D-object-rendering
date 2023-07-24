`timescale 1ns/1ns


module main 
	//#(parameter n_faces = 2564, n_vertices = 1565) 
	(	
	input clk, reset, clr_screen,
	input [16-1:0] dx_coordinate, //change in x- coordinate
	input [16-1:0] dy_coordinate, //change in y- coordinate
	input [16-1:0] dz_coordinate, //change in z- coordinate

	input [16-1:0] alpha, //change in x-angle (in degrees)
	input [16-1:0] beta, //change in y-angle (in degrees)
	input [16-1:0] gamma, //change in z-angle (in degrees)

	output vga_clk, 
	output [2:0]red, 
	output [2:0]green, 
	output [1:0]blue, 
	output Hsync, 
	output Vsync, 
	output VGA_sync_n, 
	output VGA_blank_n
	); 
	

	localparam integer n_faces = 12, n_vertices = 8 ;
	//reg [16-1:0] rom_vertices [n_vertices-1:0][3-1:0] ; // vertices - array of 3-element array (x,y,z cordinate of each vertex)
	reg signed [16-1:0] vertices [n_vertices-1:0][3-1:0]; // vertices - array of 3-element array (x,y,z cordinate of each vertex)
	reg unsigned [16-1:0] faces [n_faces-1:0][3-1:0] ; // faces - array of 3 element array (3 vertices index for each triangle)
	
	//3D object stored in ROM 
	reg signed [16-1:0] cords [n_vertices*3 -1 :0];
	reg unsigned [16-1:0] triangle [n_faces*3 - 1:0];
	
	
	 initial begin
	 $readmemh("vertices.hex",cords);
		
	 //$display("Test: %d, %d, %d",cords[0] ,cords[1] ,cords[2]);
	 $readmemh("faces.hex",triangle);
	 end

	integer i;

	initial begin
	for(i = 0; i < n_vertices; i=i+1) begin
	vertices[i][0] = cords[3*i];
	vertices[i][1] = cords[3*i+1];
	vertices[i][2] = cords[3*i+2];
	end
	
	for(i = 0; i < n_faces; i=i+1) begin
	faces[i][0] = triangle[3*i];
	faces[i][1] = triangle[3*i+1];
	faces[i][2] = triangle[3*i+2];
	end
	end
	
	

	
	//calculation of sine of angles:
	wire signed [15:0] sin_alpha, sin_beta, sin_gamma;
	sine s1 (alpha, sin_alpha);
	sine s2 (beta, sin_beta);
	sine s3 (gamma, sin_gamma);

	//reg [15:0] cos_a = 16'b0;
	//assign cos_a = cos_alpha;
	
	//calculation of cosine of angles:
	wire signed [15:0] cos_alpha, cos_beta, cos_gamma;
	//initial cos_alpha = 16'b0;
	cosine c1 (alpha, cos_alpha);
	cosine c2 (beta, cos_beta);
	cosine c3 (gamma, cos_gamma);
	reg signed [15:0] vx1, vx2, vx3, vy1a, vy1b, vy1, vy2a, vy2b, vy2, vy3, vz1a, vz1b, vz1, vz2a, vz2b, vz2, vz3 ;

	function signed [15:0] mul_3(input signed [15:0] inp_1, inp_2,inp_3);
		reg signed [47:0] product;
		begin
			product = inp_1 * inp_2 * inp_3;
			//$display("%d", product);
			mul_3 = product/10000;
			//$display("%d", mul_3);
		end
	endfunction

	function signed [15:0] mul_2(input signed [15:0] inp_1, inp_2);
		reg signed [47:0] product;
		begin
			product = inp_1 * inp_2;
			//$display("%d", product);
			mul_2 = product/100;
			//$display("%d", mul_2);
		end
	endfunction
	



	
	//rotation using eulers angles
	//always @(cos_alpha, cos_beta, cos_gamma, sin_alpha, sin_beta, sin_gamma, posedge clk) begin
	always @(posedge clk) begin
		
		//linear transformation
		//always @(dx_coordinate,dy_coordinate,dz_coordinate, posedge clk) begin

		for(i=0; i<n_vertices; i=i+1) begin

			//vertice = np.dot(vertice,rot_matrix) 

			//mul_3 m1 (vertices[i][0],cos_beta,cos_gamma, vx1);
			vx1 = mul_3 (vertices[i][0],cos_beta,cos_gamma);
			vx2 = mul_3 (vertices[i][1],cos_beta, sin_gamma);
			vx3 = mul_3 (vertices[i][2],-100,sin_beta);

//			vertices[i][0] = (vertices[i][0] * cos_beta * cos_gamma)
//					+ (vertices[i][1] * cos_beta * sin_gamma)
//					+ (vertices[i][2] * -1 * sin_beta);

			vy1a = mul_3 ( sin_alpha, sin_beta, cos_gamma);
			vy1b = mul_2 ( cos_alpha, sin_gamma);
			vy1 = mul_2 ( vertices[i][0], (vy1a - vy1b));

			vy2a = mul_3 ( sin_alpha , sin_beta, sin_gamma);
			vy2b = mul_2 ( cos_alpha, cos_gamma);
			vy2 = mul_2 ( vertices[i][1], (vy2a + vy2b));

			vy3 = mul_3 (vertices[i][2], sin_alpha, cos_beta);


//			vertices[i][1] = (vertices[i][0] * (( sin_alpha * sin_beta * cos_gamma) - (cos_alpha * sin_gamma)))
//					+ (vertices[i][1] * (( sin_alpha * sin_beta * sin_gamma) + (cos_alpha * cos_gamma)))
//					+ (vertices[i][2] * sin_alpha * cos_beta);

			vz1a = mul_3 ( cos_alpha, sin_beta, cos_gamma);
			vz1b = mul_2 ( sin_alpha, sin_gamma);
			vz1 = mul_2 ( vertices[i][0], (vz1a + vz1b));

			vz2a = mul_3 ( cos_alpha , sin_beta, sin_gamma);
			vz2b = mul_2 ( sin_alpha, cos_gamma);
			vz2 = mul_2 ( vertices[i][1], (vz2a - vz2b));

			vz3 = mul_3 (vertices[i][2], cos_alpha, cos_beta);

	
					
//			vertices[i][2] = (vertices[i][0] * (( cos_alpha * sin_beta * cos_gamma) + (sin_alpha * sin_gamma)))
//					+ (vertices[i][1] * (( cos_alpha * sin_beta * sin_gamma) - (sin_alpha * cos_gamma)))
//					+ (vertices[i][2] * cos_alpha * cos_beta);
						
						
			vertices[i][0] = vx1 + vx2 + vx3 + dx_coordinate;
			vertices[i][1] = vy1 + vy2 + vy3 + dy_coordinate;	
			vertices[i][2] = vz1 + vz2 + vz3 + dz_coordinate;	
		end

	end
		

		
////---------------rasterization------------------------------------ 

integer j;
reg signed [15:0] vert1_x, vert1_y, vert2_x, vert2_y, vert3_x, vert3_y;
reg signed [15:0] vert1_x2, vert1_y2, vert2_x2, vert2_y2, vert3_x2, vert3_y2;

reg signed [15:0] v1[1:0];
reg signed [15:0] v2[1:0];
reg signed [15:0] v3[1:0];
reg signed [15:0] helper_point[1:0];

reg raster2 ;

reg [15:0] raster_v1[1:0];
reg [15:0] raster_v2[1:0];
reg [15:0] raster_v3[1:0];

reg [15:0] raster_v1_2[1:0];
reg [15:0] raster_v2_2[1:0];
reg [15:0] raster_v3_2[1:0];

integer ydir, invslope1, invslope2, curx1, curx2;
integer scanlineY, scanlineX;
reg [16-1:0] temp;

integer ydir2, invslope12, invslope22, curx12, curx22;
integer scanlineY2, scanlineX2;
reg [16-1:0] temp2;
reg is_top_triangle, is_bot_triangle;


reg pixel_buffer [19:0] [19:0];
//reg pixel_buffer2 [19:0] [19:0];

initial begin 
	is_top_triangle = 0;
	is_bot_triangle = 0;
 	for(scanlineY = 0; scanlineY < 20; scanlineY=scanlineY+1) begin
			 	for(scanlineX = 0; scanlineX < 20; scanlineX=scanlineX+1) begin
				pixel_buffer[scanlineX][scanlineY] = 0;
				end		
	end
end

always@(posedge clk) begin
		
		//initialize buffer at each clock 
		for(scanlineY = 0; scanlineY < 20; scanlineY=scanlineY+1) begin
			 	for(scanlineX = 0; scanlineX < 20; scanlineX=scanlineX+1) begin
				pixel_buffer[scanlineX][scanlineY] = 0;
				end		
		end

		for(j = 0; j < 2; j=j+1) begin

				v1[0] = vertices[faces[j][0]][0];
				v1[1] = vertices[faces[j][0]][1];

				v2[0] = vertices[faces[j][1]][0];
				v2[1] = vertices[faces[j][1]][1];

				v3[0] = vertices[faces[j][2]][0];
				v3[1] = vertices[faces[j][2]][1];


				// Check for triangles with horizontal edge
				if (v2[1] == v3[1]) begin
					//Bottom is horizontal
					
					vert1_x = v1[0];
					vert1_y = v1[1];
					vert2_x = v2[0];
					vert2_y = v2[1];
					vert3_x = v3[0];
					vert3_y = v3[1];

					//rasterize flat triangle
					
					vert1_x2= 0;
					vert1_y2= 0;
					vert2_x2= 0;
					vert2_y2= 0;
					vert3_x2= 0;
					vert3_y2= 0;

					
					is_top_triangle = 1;
					is_bot_triangle = 0;

				end

				else if (v1[1] == v2[1]) begin
					// Top is horizontal
					
					vert1_x2 = v3[0];
					vert1_y2 = v3[1];
					vert2_x2 = v1[0];
					vert2_y2 = v1[1];
					vert3_x2 = v2[0];
					vert3_y2 = v2[1];

					//rasterize flat triangle
					
					vert1_x = 0;
					vert1_y = 0;
					vert2_x = 0;
					vert2_y = 0;
					vert3_x = 0;
					vert3_y = 0;
					
					is_top_triangle = 0;
					is_bot_triangle = 1;
				end

				else begin
					// General triangle.
					// We'll split this into two triangles with horizontal edges and process them separately.
					// Find the additional vertex that splits the triangle.
					
					//helper_point[0] = v1[0] + (((v2[1] - v1[1])* (v3[0] - v1[0]))/(v3[1] - v1[1])) ;
					helper_point[0] = v1[0] + (((((mul_2((v2[1] - v1[1]), (v3[0] - v1[0])))*100)/(v3[1] - v1[1]))/100)*100);
					helper_point[1] = v2[1];
					
					
					//rasterize top flat tri
					
					vert1_x = v1[0];
					vert1_y = v1[1];
					vert2_x = v2[0];
					vert2_y = v2[1];
					vert3_x = helper_point[0];
					vert3_y = helper_point[1];

					//rasterize bottom flat tri 
					
					vert1_x2 = v3[0];
					vert1_y2 = v3[1];
					vert2_x2 = v2[0];
					vert2_y2 = v2[1];
					vert3_x2 = helper_point[0];
					vert3_y2 = helper_point[1];
					
					is_top_triangle = 1;
					is_bot_triangle = 1;
				end
				
//---------------------------------------------------------------------------------------------------------------------------
//-----------------------Top triangle----------------------------------------------------------------------------------------
				if(is_top_triangle == 1) begin
				// Is the bottom or the top edge horizontal?
					ydir = (vert2_y - vert1_y) >= 0? 1 : -1;
					//$display("ydir: ", ydir);

				// Make sure that the horizontal edge is left-right oriented
					if(vert2_x > vert3_x) begin
					temp = vert2_x;
					vert2_x = vert3_x;
					vert3_x = temp;
					end
					//$display("vert1: (%d, %d), vert2: (%d, %d), vert3: (%d, %d)", vert1_x, vert1_y, vert2_x, vert2_y, vert3_x, vert3_y);

				// Find the inverse slope (dx/dy) for the two non-horizontal edges
					invslope1 = (ydir * 100*(vert2_x - vert1_x))/(vert2_y - vert1_y);
					invslope2 = (ydir * 100*(vert3_x - vert1_x))/(vert3_y - vert1_y);
	
				//$display("invslope1: %d, invslope2: %d", invslope1, invslope2);

				// Initialize the first scan line, which is one y-step below or above the first vertex
					curx1 = (vert1_x + invslope1);
					curx2 = (vert1_x + invslope2);
					//$display("curx1: %d, curx2: %d",curx1,curx2);

				// Step vertically. Don't include the first row, because that row only
				// contains the first vertex and we don't want to return the vertices
					
					//k = 0;
					
					for (scanlineY = 0; scanlineY < 20; scanlineY=scanlineY+1) begin

						//for (scanlineY = vert1_y + ydir*100; scanlineY < vy; scanlineY=scanlineY+100) begin
						if ((scanlineY*100 >= vert1_y + ydir*100) & (scanlineY*100 < vert2_y)) begin
								
								for (scanlineX = 0; scanlineX<20; scanlineX=scanlineX+1) begin
									if((scanlineX >= (curx1/100)) & (scanlineX <= (curx2/100))) begin
										pixel_buffer[scanlineX][scanlineY] = 1;
										//$display("scanlineX1: %d, scanlineY: %d", scanlineX, scanlineY);
									end
								end
						curx1 = (curx1 + invslope1);
						curx2 = (curx2 + invslope2);
		
						//$display("curx1: %d, curx2: %d",curx1,curx2);
						end
					end
					
					//--------------------------------------------------------------------------------------------------------
								
		// # If we're dealing with the first half of a split triangle, add the
		//    # helper point (because that's not a "real" vertex of the triangle)

					if( ((helper_point[0] == 0) & (helper_point[1] == 0)) | (ydir ==1)) begin
						 for (scanlineX = 0; scanlineX < 20; scanlineX = scanlineX + 1) begin
								if((scanlineX *100 > vert2_x) & (scanlineX*100 < vert3_x)) begin
									
									pixel_buffer[scanlineX][vert2_y/100] = 1;
									$display("inside loop: %d %d %d %d", scanlineX, vert2_y/100, vert2_x, vert3_x);
								end
						 end
					end
				end	
		

//---------------------------------------------------------------------------------------------------------------------------
//-----------------------Bottom triangle----------------------------------------------------------------------------------------

			if(is_bot_triangle == 1) begin
				// Is the bottom or the top edge horizontal?
					ydir2 = (vert2_y2 - vert1_y2) >= 0? 1 : -1;
					//$display("ydir: ", ydir);

				// Make sure that the horizontal edge is left-right oriented
					if(vert2_x2 > vert3_x2) begin
					temp2 = vert2_x2;
					vert2_x2 = vert3_x2;
					vert3_x2 = temp2;
					end
					//$display("vert1: (%d, %d), vert2: (%d, %d), vert3: (%d, %d)", vert1_x, vert1_y, vert2_x, vert2_y, vert3_x, vert3_y);

				// Find the inverse slope (dx/dy) for the two non-horizontal edges
					invslope12 = (ydir2 * 100*(vert2_x2 - vert1_x2))/(vert2_y2 - vert1_y2);
					invslope22 = (ydir2 * 100*(vert3_x2 - vert1_x2))/(vert3_y2 - vert1_y2);
	
				$display("invslope12: %d, invslope22: %d", invslope12, invslope22);

				// Initialize the first scan line, which is one y-step below or above the first vertex
					curx12 = (vert1_x2 + invslope12);
					curx22 = (vert1_x2 + invslope22);
					//$display("curx12: %d, curx22: %d",curx12,curx22);

				// Step vertically. Don't include the first row, because that row only
				// contains the first vertex and we don't want to return the vertices
					
					//k = 0;
					
					for (scanlineY2 = 19; scanlineY2 >= 0 ; scanlineY2=scanlineY2-1) begin
							//$display("scanlineY: %d, vert1_y: %d, 
						//for (scanlineY = vert1_y + ydir*100; scanlineY < vy; scanlineY=scanlineY+100) begin
						if ((scanlineY2*100 <= vert1_y2 + ydir2*100) & (scanlineY2*100 > vert2_y2)) begin
								//$display("Y loop working");
								for (scanlineX2 = 0; scanlineX2<20; scanlineX2=scanlineX2+1) begin
									if((scanlineX2 >= (curx12/100)) & (scanlineX2 <= (curx22/100))) begin
										$display("scanlineX1: %d, scanlineY: %d", scanlineX2, scanlineY2);
										pixel_buffer[scanlineX2][scanlineY2] = 1;
									end
								end
						curx12 = (curx12 + invslope12);
						curx22 = (curx22 + invslope22);
		
						//$display("curx12: %d, curx22: %d",curx12,curx22);
						end
					end
				
			//--------------------------------------------------------------------------------------------------------
											
			// # If we're dealing with the first half of a split triangle, add the
			//    # helper point (because that's not a "real" vertex of the triangle)

					if( ((helper_point[0] == 0) & (helper_point[1] == 0)) | (ydir ==1)) begin
						 for (scanlineX = 0; scanlineX < 20; scanlineX = scanlineX + 1) begin
								if((scanlineX *100 > vert2_x2) & (scanlineX*100 < vert3_x2)) begin
									
									pixel_buffer[scanlineX][vert2_y2/100] = 1;
									$display("inside loop: %d %d %d %d", scanlineX, vert2_y2/100, vert2_x2, vert3_x2);
								end
						 end
					end
			end
		end
end


VGA VGAdriver( clk, reset, clr_screen, pixel_color, 
					start_rd, vga_clk, red, green, blue, 
					Hsync, Vsync, VGA_sync_n, VGA_blank_n );
								 
integer Xin = 0;
integer Yin = 0;

assign pixel_color = pixel_buffer[Yin][Xin];
always@(posedge clk) begin
//update pixel color according to index from pixel buffer
	
	if(start_rd) begin
		Xin = Xin + 1;
		if (Xin > 19 & Yin < 20) begin
			Yin = Yin + 1; 
			Xin = 0;
		end
		else if (Xin > 19 & Yin > 19) begin
			Xin = 0;
			Yin = 0;
		end
		else 
			Xin = 0;
	end
	else begin
		Xin = 0; Yin = 0;
	end
end 				


endmodule

