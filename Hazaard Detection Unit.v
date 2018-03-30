module HazardDetectionUnit(IDIE_MemRead,IDIE_rt,IFID_rs,IFID_rt,IFIDWrite,PCWrite,StallOrControl,IFID_MemWrite,IFID_MemRead ,IFID_RegWrite,IFID_branch);
input wire IDIE_MemRead , IFID_MemWrite , IFID_MemRead , IFID_RegWrite , IFID_branch; /*MemRead checks if instruction is lw , MemWrite checks if instruction is sw , RegWrite checks if instruction is R-format , Branch bayna ya3ni */
input wire[4:0] IDIE_rt,IFID_rs,IFID_rt;
output reg IFIDWrite,PCWrite,StallOrControl; /*hold IFID and PC for one clk cycle*/

always@(IFID_rs or IFID_rt or IDIE_rt or IDIE_MemRead or IFID_MemWrite or IFID_MemRead or IFID_RegWrite or IFID_branch)
begin

		if( 
			/* if rt of lw in IDIE is equal to rs of sw in IFID */ (IDIE_MemRead && IFID_MemWrite && (IDIE_rt == IFID_rt))
		||      /* if rt of lw in IDIE is equal to rs of lw in IFID */ (IDIE_MemRead && IFID_MemRead && (IDIE_rt == IFID_rs))
		||      /* if rt of lw in IDIE is equal to rt of R-format in IFID */ (IDIE_MemRead && IFID_RegWrite && (IDIE_rt == IFID_rt))
		||	/* if rt of lw in IDIE is equal to rs of R-format in IFID */ (IDIE_MemRead && IFID_RegWrite && (IDIE_rt == IFID_rs))
		||      /* if rt of lw in IDIE is equal to rs of Beq in IFID */ (IDIE_MemRead && IFID_branch && (IDIE_rt == IFID_rs))
		||      /* if rt of lw in IDIE is equal to rt of Beq in IFID */ (IDIE_MemRead && IFID_branch && (IDIE_rt == IFID_rt))
		   )		
		begin 
			IFIDWrite=1; //hold of IFID pipeline register
			PCWrite=1; //hold of PC	
			StallOrControl=1; // Put Zeroes on Control Signals
		end
		
		else
		begin
			IFIDWrite=0;
			PCWrite=0;
			StallOrControl=0;
		end
end
endmodule 

module HDUTB ;

reg IDIE_MemRead , IFID_MemWrite , IFID_MemRead , IFID_RegWrite;
reg[4:0] IDIE_rt,IFID_rs,IFID_rt;
wire IFIDWrite,PCWrite;

HazardDetectionUnit HDU1 (IDIE_MemRead,IDIE_rt,IFID_rs,IFID_rt,IFIDWrite,PCWrite,IFID_MemWrite,IFID_MemRead ,IFID_RegWrite);

initial
begin

$monitor("DEMemRead:%d  DErt:%d  FDrs:%d  FDRegWR:%d  FDrt:%d  FDMemRead:%d  FDMemWrite:%d  FDWRITE:%d  PCWRITE:%d ",IDIE_MemRead,IDIE_rt,IFID_rs,IFID_RegWrite,IFID_rt,IFID_MemRead,IFID_MemWrite,IFIDWrite,PCWrite);
#1
IDIE_MemRead=1; IFID_MemWrite=1; IDIE_rt=10; IFID_rs=10;
#1
IFID_rs=9;
#1
IFID_rs=10; IFID_MemWrite=0; IFID_MemRead=1;
#1
IFID_MemRead=0; IFID_RegWrite=1;
#1
IFID_MemRead=1;
#1
IFID_rs=9 ; IFID_rt=9;
#1
IFID_rt=10;


end

endmodule 

