module MEM_WB_register(
WB_control,MemtoReg,RegWrite,
ReadData,_ReadData,
AluResult,_AluResult,
Destenation,_Destenation,
clk
);
input clk;

input [1:0] WB_control;
output reg MemtoReg,RegWrite;

input wire [31:0] ReadData;
output reg [31:0] _ReadData;

input wire [31:0] AluResult;
output reg [31:0] _AluResult;

input wire [4:0] Destenation;
output reg [4:0] _Destenation;

always@(posedge clk)
begin
MemtoReg<=WB_control[0];
RegWrite<=WB_control[1];
_ReadData<=ReadData;
_AluResult<=AluResult;
_Destenation<=Destenation;
end
initial begin
MemtoReg<=0;
RegWrite<=0;
_ReadData<=0;
_AluResult<=0;
_Destenation<=0;
end

endmodule
