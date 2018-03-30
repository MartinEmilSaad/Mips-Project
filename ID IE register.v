module ID_IE_register(WB_control,M_control,EX_control,branch,
_WB_control,_M_control,RegDst,AluOp,AluSrc,_branch,
pc_plus_four,_pc_plus_four,
read_data1,read_data2,_read_data1,_read_data2,
immediate,_immediate,alu_control_input,
rs,rt,rt_extra,rd,
_rs,_rt,_rt_extra,_rd,
clk
);
input clk;
input wire [1:0] WB_control;
output reg [1:0] _WB_control;

input wire [1:0] M_control;
output reg [1:0] _M_control;

input wire [3:0] EX_control;
output reg [1:0] AluOp;output reg RegDst,AluSrc;

input wire branch;
output reg _branch;

input wire [31:0] pc_plus_four;output reg [31:0] _pc_plus_four;
input wire [31:0] read_data1,read_data2;output reg [31:0] _read_data1,_read_data2;
input wire [31:0] immediate;output reg [31:0] _immediate;output reg [5:0] alu_control_input;
input [4:0] rs,rt,rt_extra,rd;output reg [4:0] _rs,_rt,_rt_extra,_rd;

always@(posedge clk)
begin
_WB_control<=WB_control;_M_control<=M_control;
RegDst<=EX_control[0];AluOp<=EX_control[2:1];AluSrc<=EX_control[3];
_branch<=branch;
_pc_plus_four<=pc_plus_four;
_read_data1<=read_data1;_read_data2<=read_data2;
_immediate<=immediate;alu_control_input<=immediate[5:0];
_rs<=rs;_rt<=rt;_rt_extra<=rt_extra;_rd<=rd;
end

initial begin
_WB_control<=0;_M_control<=0;
RegDst<=0;AluOp<=0;AluSrc<=0;
_branch<=0;
_pc_plus_four<=0;
_read_data1<=0;_read_data2<=0;
_immediate<=0;alu_control_input<=0;
_rs<=0;_rt<=0;_rt_extra<=0;_rd<=0;

end


endmodule


