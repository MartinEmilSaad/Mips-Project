module registerfile(read_register1,read_register2,write_register,in_data,write_enable,read_data1,read_data2,clk) ;
input [4:0] read_register1,read_register2,write_register;
input write_enable,clk;
input [31:0] in_data;
output wire  [31:0] read_data1,read_data2;
reg[31:0] R [0:31];

assign read_data1=R[read_register1];
assign read_data2=R[read_register2];

always @(negedge clk)
begin
if(write_enable==1)
begin
R[write_register]<=in_data;
end
end

initial
begin
	//zero register
	R[0]=0;
	//$t(0-7)
	R[8]=8;R[9]=9;R[10]=10;R[11]=11;R[12]=12;R[13]=13;R[14]=14;R[15]=15;
	//$S(0-7)
	R[16]=16;R[17]=17;R[18]=18;R[19]=19;R[20]=20;R[21]=21;R[22]=22;R[23]=23;
	//$t(8,9)
	R[24]=24;R[25]=25;
end

endmodule


module test_register_file;
reg [4:0] read_register1,read_register2,write_register;
reg write_enable,clk;
reg [31:0] in_data;
wire [31:0] read_data1,read_data2;
initial
begin
$monitor ($time,,,,,"%d  %d  %d",clk,read_data1,read_data2);
clk=1;write_enable=1;in_data=10;write_register=0;
#10
in_data=20;write_register=0;
#10
in_data=90;write_register=1;
#10
read_register1=0;read_register2=1;
#10
read_register2=3;
#10
in_data=100;write_register=30;
#10
read_register1=4;read_register2=30;
end
always
begin
#5 clk=~clk;
end

registerfile RF(read_register1,read_register2,write_register,in_data,write_enable,read_data1,read_data2,clk) ;
endmodule