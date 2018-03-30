module instruction_memory(read_address,out);
input [31:0] read_address;
output wire [31:0] out;
reg [31:0] IM[0:1023];
assign out=IM[read_address>>2];


initial
begin
IM[0]<=0;
IM[1]<=0;
IM[2]<=0;
IM[3]<=0;
	//$readmemh("Instructions.hex",IM);
end

endmodule
