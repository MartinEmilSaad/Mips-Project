module DataMemory(ReadData,Address,WriteData,MemWrite,MemRead,Clk);
	output wire[31:0] ReadData;
	input wire[31:0] Address;
	input wire[31:0] WriteData;
	input wire MemWrite;
	input wire MemRead;
	input wire Clk;

	reg [31:0] DataMemory[0:1023];

	assign ReadData = DataMemory[Address>>2];
	always @(posedge Clk) begin
//		ReadData <= DataMemory[Address];
		if(MemWrite == 1) begin
			DataMemory[Address>>2]<=WriteData;
		end
	end

/*	always @(Address or WriteData or MemWrite or MemRead) begin
		if(MemWrite == 1) begin
			DataMemory[Address]=WriteData;
			ReadData = DataMemory[Address];
		end
		else begin
			ReadData = DataMemory[Address];			
		end
	end
*/
	// Filling File & Put the values in Data Memory

	reg[31:0] i;
	integer file;
	initial begin
	/*	i=0;
		file = $fopen("D:\DM.txt");
		$fmonitor(file,"%b",i);
		for(i=0;i<1024;i=i+1) begin
			#1
			i=i;
		end
		#20	*/
		//$readmemb("D:\DM.txt",DataMemory);
		DataMemory[0]=0;DataMemory[1]=1;DataMemory[2]=2;DataMemory[3]=3;DataMemory[4]=4;
		DataMemory[5]=5;DataMemory[6]=6;DataMemory[7]=7;DataMemory[8]=8;DataMemory[9]=9;
		/*DataMemory[10]=10;DataMemory[11]=11;DataMemory[12]=12;DataMemory[13]=13;DataMemory[14]=14;
		DataMemory[15]=15;DataMemory[16]=16;DataMemory[17]=17;DataMemory[18]=18;DataMemory[19]=19;*/
	end

endmodule

module Test_DataMemory;
	wire[31:0] ReadData;
	reg[31:0] Address;
	reg[31:0] WriteData;
	reg MemWrite;
	reg MemRead;
	reg Clk;
	initial begin
		#2048
		Clk = 0;
		MemWrite = 0;
		#10
		Address = 0;
		#1
		$display("Address is %d ,, Data is %d ,, MemWrite is %d",Address,$signed(ReadData),MemWrite);

		#10
		MemWrite = 1;
		Address = 993;
		WriteData = 0;
		#1
		$display("Address is %d ,, Data is %d ,, MemWrite is %d",Address,$signed(ReadData),MemWrite);

		#10
		MemWrite = 0;
		Address = 993;
		#1
		$display("Address is %d ,, Data is %d ,, MemWrite is %d",Address,$signed(ReadData),MemWrite);

		#10
		Address=992;
		#1
		$display("Address is %d ,, Data is %d ,, MemWrite is %d",Address,$signed(ReadData),MemWrite);

		#10
		MemWrite = 1;
		Address = 1023;
		WriteData = -20;		
		#1
		$display("Address is %d ,, Data is %d ,, MemWrite is %d",Address,$signed(ReadData),MemWrite);

		#10
		Address = 1023;
		MemWrite = 0;
		#1
		$display("Address is %d ,, Data is %d ,, MemWrite is %d",Address,$signed(ReadData),MemWrite);
		
	end
	DataMemory D1(ReadData,Address,WriteData,MemWrite,MemRead,Clk);
	always begin
		#1 Clk = ~Clk;
	end
endmodule