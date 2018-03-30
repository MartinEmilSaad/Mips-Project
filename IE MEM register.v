module IE_MEM_register(WB_control,M_control,
_WB_control,MemRead,MemWrite,
alu_result,_alu_result,
immediate,_immediate,
mux1,_mux1,
mux2,_mux2,
clk
);
input clk;
input wire [1:0] WB_control;
output reg [1:0] _WB_control;

input wire [1:0] M_control;
output reg MemRead,MemWrite;

input wire [31:0] alu_result;
output reg [31:0] _alu_result;

input wire [31:0] immediate;
output reg [31:0] _immediate;

input wire [31:0] mux1;
output reg [31:0] _mux1;

input wire [4:0] mux2;
output reg [4:0] _mux2;

always@(posedge clk)
begin
_WB_control<=WB_control;
MemRead<=M_control[1];
MemWrite<=M_control[0];
_alu_result<=alu_result;
_immediate<=immediate;
_mux1<=mux1;
_mux2<=mux2;
end

initial begin
_WB_control<=0;
MemRead<=0;
MemWrite<=0;
_alu_result<=0;
_immediate<=0;
_mux1<=0;
_mux2<=0;
end

endmodule
