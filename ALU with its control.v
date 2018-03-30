module ALU_CNTRL(op,ALUOp,func);

input wire[5:0] func;
input wire[1:0] ALUOp;
output reg[3:0] op;//output

always@(ALUOp or func)
begin

	case(ALUOp)
/*sw,lw */	2'b00 : begin
		         op<=4'b0010;
		end

/*beq*/		2'b01 : begin
		         op<=4'b0110;
		end

/*RType*/	2'b10 : begin
        	        case(func)
		        32 : begin  op<=4'b0010; end //add
		        36 : begin  op<=4'b0000; end //and
		        34 : begin  op<=4'b0110; end //sub
		        0  : begin  op<=4'b0100; end //sll
		        2  : begin  op<=4'b0101; end //srl
		        37  : begin  op<=4'b0001; end //or
			default : begin op=4'bxxxx; end
		        endcase
			end	

		default : begin
			   op<=4'bxxxx;
		end
	endcase
end
endmodule



/*********ALU CONTROL TESTBENCH**********/

module AluCntrlTB ;

reg[5:0] func;
reg[1:0] ALUOp;
wire[3:0] op ;

ALU_CNTRL a1(op,ALUOp,func);

initial
begin

$monitor("%b  %b  %d",ALUOp,op,func);
#2
ALUOp = 2'b00;
#2
ALUOp = 2'b01;
#2
ALUOp = 2'b10;
func = 0;
#2
ALUOp=2'b10;
func = 2; 
end

endmodule


/*********ALU MODULE**********/


module ALU(A,B,op,shift_amt,result,zeroflag);
	
input wire[31:0] A;
input wire[31:0] B;
input wire[3:0] op;
input wire[4:0] shift_amt;
output integer result;
output wire zeroflag;
always @(A or B or op or shift_amt) begin
		case(op)
			4'b0010: begin
				result <= $signed(A) + $signed(B);
				//if((A[31] == B[31]) && (A[31] != result[31])) overflow <= 1;
				//else overflow <= 0;
			end
			4'b0110: begin
				result <= $signed(A) - $signed(B);
				//if((A[31] == B[31]) && (A[31] != result[31])) overflow <= 1;
				//else overflow <= 0;
			end
			4'b0000: begin
				result <= A & B;
				//overflow <= 0;
			end
			4'b0001: begin
				result <= A | B;
				//overflow <= 0;
			end
			4'b0100: begin
				result <= B << shift_amt;
				//overflow <= 0;
			end
			4'b0101: begin
				result <= B >> shift_amt;
				//overflow <= 0;
			end
			/*6: begin
				result <= $signed(A) >>> shift_amt;
				overflow <= 0;
			end
			7: begin
				result <= $signed(A)>$signed(B);
				overflow <= 0;
			end
			8: begin
				result <= $signed(A)<$signed(B);
				overflow <= 0;
			end*/
			default: begin
				result <= 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx;
				//overflow <= 1'bx;
			end
		endcase
	end
assign zeroflag = (result==0)?1'b 1:1'b 0;
endmodule

/*********ALU ONLY TESTBENCH**********/

module test_ALU;

	integer  A,B;
	reg [3:0] op;
	reg [4:0] shift_amt;
	wire zeroflag;
	wire[31:0] result;
	ALU A1(A,B,op,shift_amt,result,zeroflag);

	initial begin
		A = 198456911;
		B = -198456911;
//		B = 198456910;
		op=2;
		shift_amt=3;
		$monitor ("op: %d \nA: %b \nB: %b \nResult: %b  %d \n" ,op,A,B,result,$signed(result));
	end

endmodule 


/*********ALU + ALU CONTROL TESTBENCH**********/

module ALUandCNTRLTB ;

wire[3:0]op;
reg[5:0] func;
reg[1:0] ALUOp;

wire[31:0]result;
integer A,B;
reg[4:0]shift_amt;
wire zeroflag;

ALU_CNTRL alucntrl1(op,ALUOp,func);
ALU alu1(A,B,op,shift_amt,result,zeroflag);

initial
begin
$monitor ("op: %b \nA: %b \nB: %b \nResult: %b  %d \nZero: %d \n" ,op,A,B,result,$signed(result),zeroflag);
#2
A = 198456911;
B = -198456911;
//	B = 198456910;
shift_amt=3;
ALUOp = 2'b00;
//      func = 32;

end
endmodule