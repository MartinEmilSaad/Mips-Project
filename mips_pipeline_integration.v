module mips_pipeline_integration(clk,x);
	output x;
	input wire clk; // Will be input wire clk

	/************************************************************
				 IF STAGE
	*************************************************************/

	wire[31:0] pc_plus_four,pc_branch,PCInput;
	wire[31:0] read_address_im;
	assign pc_plus_four = read_address_im+4;

	//PC MUX Control Using AND
	wire pc_mux_control;
	wire IDIE_branch,equal_flag;
	assign x=equal_flag;
	and A1(pc_mux_control,IDIE_branch,equal_flag); // Branch Control from Control Unit ,, Equal Flag from Comparator or ALU
	/* Branch Control May Change */

	// PC MUX Module
	mux2 PCMux(pc_plus_four,pc_branch,pc_mux_control,PCInput); // pc_branch From IE Stage

	// PC Module
	wire hazard_pc_hold; // From ID Stage ( Hazard Detection unit )

	pc_register PCReg(PCInput,read_address_im,hazard_pc_hold,clk);

	// Instruction Memory Module
	wire[31:0] out_im;
	instruction_memory IM(read_address_im,out_im);

	// IF/ID Pipeline Register
	wire [31:0] IFID_pc_plus_four;
	wire [5:0] op_code;
	wire [4:0] rr1,rr2;
	wire [15:0] immediate_address;
	wire [4:0] rs,rt,rt_extra,rd;
	wire IFID_hold;
	IF_ID_register IFIDReg(pc_plus_four,out_im,IFID_pc_plus_four,op_code,rr1,rr2,immediate_address,rs,rt,rt_extra,rd,IFID_hold,clk);//na2es input bta3 control hazard	

	/************************************************************
				 ID STAGE
	*************************************************************/

	// Register File
	wire[4:0] write_register;
	wire[31:0] write_data,read_data1,read_data2;
	wire[4:0] MEMWB_DestinationReg;wire MEMWB_RegWrite;
	registerfile RF(rr1,rr2,MEMWB_DestinationReg,write_data,MEMWB_RegWrite,read_data1,read_data2,clk); 
	// write_register,write_data,RegWrite from WB Stage

	// Sign Extend
	wire[31:0] immediate_extended;
	sign_extend SE(immediate_address,immediate_extended);

	// Control Unit
	wire[1:0] AluOp;wire RegDst, branch_control , MemRead , MemtoReg , MemWrite , AluSrc , RegWrite ;
	ControlUnit CU(RegDst , branch_control , MemRead , MemtoReg , AluOp , MemWrite , AluSrc , RegWrite ,op_code );


	// MUX To Create Stalls if Required
	wire[8:0] control_zeroes;
	assign control_zeroes=9'b000000000;

	/****** 	     Hazard Detection Unit Part			*****/
	// Hazard Detection Control Unit
	wire[1:0] IDIE_M_control;
	wire[4:0] IDIE_rt;wire StallOrControl;
	HazardDetectionUnit HDU(IDIE_M_control[1],IDIE_rt,rs,rt,IFID_hold,hazard_pc_hold,StallOrControl,MemWrite,MemRead,RegWrite,branch_control);
	
	wire[8:0] control_signals,control_signals_;
	assign control_signals = {RegWrite,MemtoReg,MemRead,MemWrite,AluSrc,AluOp,RegDst,branch_control};
	mux2 ControlSignalsOrZeroes(control_signals,control_zeroes,StallOrControl,control_signals_); // StallOrControl Comes From Hazard Detection Unit


	// ID/IE Pipeline Register
	wire[1:0] IDIE_WB_control,IDIE_AluOp;
	wire[31:0] IDIE_immediate_extended;
	wire[31:0] IDIE_pc_plus_four;
	wire[31:0] IDIE_read_data1,IDIE_read_data2;
	wire[4:0] IDIE_rs,IDIE_rt_extra,IDIE_rd;
	wire[5:0] alu_control_input;wire IDIE_RegDst,IDIE_AluSrc;

	ID_IE_register IDIEReg(control_signals_[8:7],control_signals_[6:5],control_signals_[4:1],control_signals_[0],
	IDIE_WB_control,IDIE_M_control,IDIE_RegDst,IDIE_AluOp,IDIE_AluSrc,IDIE_branch,
	IFID_pc_plus_four,IDIE_pc_plus_four,
	read_data1,read_data2,IDIE_read_data1,IDIE_read_data2,
	immediate_extended,IDIE_immediate_extended,alu_control_input,
	rs,rt,rt_extra,rd,
	IDIE_rs,IDIE_rt,IDIE_rt_extra,IDIE_rd,
	clk
	);
	/************************************************************
				 EX STAGE
	*************************************************************/
	// RegDst Mux
	wire[4:0] DestinationReg;
	wire[1:0] ALUMux1Selector,ALUMux2Selector;
	wire[31:0] ALUIn1,ALUIn2_ALUSrcIn,ALUIn2;

	wire[31:0] EXMEM_ALUResult;
	wire[31:0] MEMWB_ALUResult;

	mux2 RegDstMux(IDIE_rt_extra,IDIE_rd,IDIE_RegDst,DestinationReg);
	mux3 ALUMux1(IDIE_read_data1,write_data,EXMEM_ALUResult,ALUMux1Selector,ALUIn1); // MEMWB_DestinationReg From WB Stage
	mux3 ALUMux2(IDIE_read_data2,write_data,EXMEM_ALUResult,ALUMux2Selector,ALUIn2_ALUSrcIn);
	mux2 ALUIn2Mux(ALUIn2_ALUSrcIn,IDIE_immediate_extended,IDIE_AluSrc,ALUIn2);
	// ALU Control
	wire[3:0] op;
	ALU_CNTRL ALUControl(op,IDIE_AluOp,alu_control_input);
	
	// ALU
	wire[31:0] ALUResult;
	ALU ALUUnit(ALUIn1,ALUIn2,op,IDIE_immediate_extended[10:6],ALUResult,equal_flag);
	
	// Branch Case Adder
	wire[31:0] IDIE_immediate_extended_shifted_by_two = IDIE_immediate_extended<<2;
	assign pc_branch = IDIE_immediate_extended_shifted_by_two + IDIE_pc_plus_four;

	// Forwarding Unit
	wire[4:0] EXMEM_DestinationReg;wire  EXMEM_RegWrite;
	Forwarding_Unit FWUnit( ALUMux1Selector , ALUMux2Selector ,  IDIE_rs , IDIE_rt , EXMEM_DestinationReg , MEMWB_DestinationReg , EXMEM_RegWrite, MEMWB_RegWrite );
	
	// EXMEM Register
	wire[31:0] EXMEM_immediate_extended;
	wire[1:0] EXMEM_WB_control;
	wire[31:0] EXMEM_ALUIn2_ALUSrcIn;wire EXMEM_MemRead,EXMEM_MemWrite;
	IE_MEM_register IEMEMReg(IDIE_WB_control,IDIE_M_control,
	EXMEM_WB_control,EXMEM_MemRead,EXMEM_MemWrite,
	ALUResult,EXMEM_ALUResult,
	IDIE_immediate_extended,EXMEM_immediate_extended,
	ALUIn2_ALUSrcIn,EXMEM_ALUIn2_ALUSrcIn,
	DestinationReg,EXMEM_DestinationReg,
	clk
	);

	/************************************************************
				 MEM STAGE
	*************************************************************/

	// Data Memory
	wire[31:0] ReadData,MEMWB_ReadData;
	assign EXMEM_RegWrite = EXMEM_WB_control[1];wire MEMWB_MemtoReg;

	DataMemory DM(ReadData,EXMEM_ALUResult,EXMEM_ALUIn2_ALUSrcIn,EXMEM_MemWrite,EXMEM_MemRead,clk);
	
	// MEM WB Register
	MEM_WB_register MEMWBReg(
	EXMEM_WB_control,MEMWB_MemtoReg,MEMWB_RegWrite,
	ReadData,MEMWB_ReadData,
	EXMEM_ALUResult,MEMWB_ALUResult,
	EXMEM_DestinationReg,MEMWB_DestinationReg,
	clk);

	/************************************************************
				 WB STAGE
	*************************************************************/
	mux2 MemToRegMux(MEMWB_ALUResult,MEMWB_ReadData,MEMWB_MemtoReg,write_data);

	

endmodule


module testPL;
reg clk;
initial 
begin
clk=0;
end
always
begin
#5 clk=!clk;
end
mips_pipeline_integration MP(clk);

endmodule
