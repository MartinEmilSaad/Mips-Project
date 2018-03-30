module M5(in1,in2,mux_control,o1);
input [4:0] in1,in2;
input mux_control;
output reg [4:0] o1; 
always @(in1 or in2 or mux_control)
begin
if(mux_control==0)
begin  o1<=in1;     end
else if(mux_control==1)
begin   o1<=in2;     end
else
begin    o1<=5'bxxxxx;          end
end
endmodule


