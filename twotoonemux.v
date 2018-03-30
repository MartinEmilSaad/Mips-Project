module mux2(in1,in2,mux_control,o1);
input [31:0] in1,in2;
input mux_control;
output integer o1; 
always @(in1 or in2 or mux_control)
begin
if(mux_control==0)
begin  o1<=in1;     end
else if(mux_control==1)
begin   o1<=in2;     end
else
begin    o1<=32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx;          end
end
endmodule


module test_mux2;
reg mux_control;
reg [31:0]in1,in2;
wire[31:0] o1;
initial
begin
$monitor ($time,,,,"%d   %d  %d %d",in1,in2,mux_control,o1);
mux_control=0;
#6
in1=30;in2=0;
#6
mux_control=1;
#6
mux_control=1'bx;

end
mux2 M(in1,in2,mux_control,o1);

endmodule