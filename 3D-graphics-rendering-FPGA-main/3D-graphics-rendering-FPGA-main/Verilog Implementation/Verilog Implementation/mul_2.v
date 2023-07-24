
module mul_2 (input [15:0] inp_1, input [15:0] inp_2, output [15:0] outp);

wire signed [31:0] product;

assign product = inp_1 * inp_2;

assign outp = product/100;

//Testbench part
wire signed [15:0] a1 = -9306;
wire signed [15:0] a2 = 99;
wire signed [31:0] op;
assign op = a1*a2;
wire signed [15:0] opf;
assign opf = op/100;

always@(*) begin
	$display("%d, %d, %d, %d",a1,a2,op,opf); 
end

endmodule
