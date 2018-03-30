module ControlUnit ( RegDst , Branch , MemRead , MemtoReg , AluOp , MemWrite , AluSrc , RegWrite ,opcode );


input [5:0] opcode;

output reg RegDst , Branch , MemRead , MemtoReg , MemWrite , AluSrc , RegWrite;

output reg[1:0] AluOp;


parameter R_Format =6'b000000;

parameter SW =6'b101011;

parameter LW = 6'b100011;

parameter Beq = 6'b000100;


always @ ( opcode )   //////////no need for a clock here , combintional circuit.

begin




if( opcode == R_Format ) 
	 
      	begin	
	RegDst <= 1; 
	Branch <= 0;
	MemRead <= 0;
	MemtoReg <= 0;
	AluOp <= 2'b 10 ;
	MemWrite <= 0;
	AluSrc <= 0;
	RegWrite <= 1;
	end


 else if ( opcode ==LW)
		
        begin

		RegDst <= 0;
		Branch <= 0;
		MemRead <= 1;
		MemtoReg <= 1;
		AluOp <= 2'b 00;
		MemWrite <= 0;
		AluSrc <= 1;
		RegWrite <= 1;
	end



 else if ( opcode == SW ) 
	begin

		RegDst <=1'bx;
		Branch <= 0;
		MemRead <= 0;
		MemtoReg <= 1'bx;
		AluOp <= 2'b 00 ;
		MemWrite <= 1;
		AluSrc <= 1;
		RegWrite <= 0;
	end




else if (opcode ==Beq)
	begin

		RegDst <= 1'bx;
		Branch <= 1;
		MemRead <= 0;
		MemtoReg <= 1'bx;
		AluOp <= 2'b 01;
		MemWrite <= 0;
		AluSrc <= 0;
		RegWrite <= 0;
	end


else
	begin

		RegDst <= 1'bx;
		Branch <= 0;
		MemRead <= 0;
		MemtoReg <= 1'bx;
		AluOp <= 2'b xx;
		MemWrite <= 0;
		AluSrc <= 0;
		RegWrite <= 0;
	end


end


endmodule








////////////*************** Test Bench for ControlUnit ***********////////////////



module testcontrolunit;



 reg[5:0] opcode;

 wire RegDst , Branch , MemRead , MemtoReg , MemWrite , AluSrc , RegWrite;

 wire[1:0] AluOp;


ControlUnit mycu( RegDst , Branch , MemRead , MemtoReg , AluOp , MemWrite , AluSrc , RegWrite ,opcode );


initial 

begin

$monitor ( $time,,,,"outputs in order of module arguments are : %b  %b  %b  %b  %b  %b  %b  %b %b",RegDst , Branch , MemRead , MemtoReg , AluOp ,
					 MemWrite , AluSrc , RegWrite ,opcode ) ;


opcode = 6'b000000;
#10

opcode = 6'b101011;

#10

opcode = 6'b100111;

#10

opcode = 6'b000100;

#10

opcode = 6'b111111;   ///       Imaginary case just for experiment.

end




endmodule












