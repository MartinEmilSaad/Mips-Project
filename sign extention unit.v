module sign_extend(in,out);
input [15:0] in;
output [31:0] out;
assign out [15:0]=in;
wire A;
assign A=in[15];
reg [15:0] temp;
always@(in,A)
begin
	if(A==0)
		temp<=16'b 0000_0000_0000_0000;
	else
		temp<=16'b 1111_1111_1111_1111;
end
assign out[31:16]=temp;
endmodule

module test_sign_extention;
reg [15:0] in;
wire [31:0] out;
sign_extend SE(in,out);
initial
begin
in=20;
$monitor("%b   %b",in,out);

#10
in=-110;

end


endmodule