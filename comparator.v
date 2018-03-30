module comparator(out,in1,in2);
	input [31:0] in1,in2;
	output out;
	wire[31:0] result;
	assign out = (in1 == in2)?1:0;
endmodule

module test_comparator;
	reg[31:0] in1,in2;
	wire out;
	initial begin
		$monitor("In1:%h,In2:%h,Out:%h",in1,in2,out);
		in1=32'hFFFFFFFF;
		in2=32'hFFFFFFF0;
		#10
		in1=32'hFFFFEFFF;
		in2=32'hFFFFFFFF;
		#10
		in1=32'hFFFFFFFF;
		in2=32'hFFFF3FFF;
		#10
		in1=32'hFFFFFFFF;
		in2=32'hFFFFFFFF;
	end
	comparator C1(out,in1,in2);
endmodule
