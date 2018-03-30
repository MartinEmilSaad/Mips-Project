module pc_register(i,o,hold,clk);//i is the input,o is the output
input [31:0] i;input hold,clk;//hold is the output of hazard control unit
output reg[31:0] o;

initial
begin
o=0;
end

always@(posedge clk)
begin
if(!hold)
begin
o<=i;
end
else
begin
o<=o;
end

end
endmodule

module test_pc;
reg [31:0] i;reg hold,clk;
wire [31:0] o;

initial
begin
clk=0;hold=0;
i=0;
$monitor($time,,,"%d  %d  %d",i,o,hold);
#22
hold=1;
#5
i=20;
#2
hold=0;
#2
i=100;
#10
i=200;
#10
i=300;
end

always
begin
#5
clk=~clk;
end
 pc_register PC(i,o,hold,clk);
endmodule
