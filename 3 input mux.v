module mux3(in1,in2,in3,mux_control,o1);
input [31:0] in1,in2,in3;
input [1:0] mux_control;
output integer o1; 
always @(in1 or in2 or in3 or mux_control)
begin
if(mux_control==0)
begin  o1<=in1;     end
else if(mux_control==1)
begin   o1<=in2;     end
else if(mux_control==2)
begin   o1<=in3;     end
else if(mux_control==3)
begin   o1<=32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx;     end
else
begin    o1<=32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx;          end
end
endmodule


module test_mux3;
reg [1:0] mux_control;
reg [31:0]in1,in2,in3;
wire[31:0] o1;
initial
begin
$monitor ($time,,,,"%d %d %d %d %d",in1,in2,in3,mux_control,o1);
mux_control=0;
#6
in1=22;in2=3;in3=1996;
#6
mux_control=1;
#6
mux_control=2;
#6
mux_control=3;
end
mux3 M(in1,in2,in3,mux_control,o1);

endmodule
