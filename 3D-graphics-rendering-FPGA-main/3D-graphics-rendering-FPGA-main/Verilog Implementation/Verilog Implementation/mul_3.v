
module mul_3 (input [15:0] inp_1, input [15:0] inp_2, input [15:0] inp_3, output [15:0] outp);

wire signed [47:0] product;

assign product = inp_1 * inp_2 * inp_3;

assign outp = product/10000;

//Testbench part
wire signed [15:0] a1 = -9306;
wire signed [15:0] a2 = 99;
wire signed [15:0] a3 = 99;
wire signed [47:0] op;
assign op = a1*a2*a3;
wire signed [15:0] opf;
assign opf = op/10000;

always@(*) begin
	$display("%d, %d, %d, %d",a1,a2,a3,op,opf); 
end

endmodule
