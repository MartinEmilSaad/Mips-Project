module  Forwarding_Unit ( control_mux1 , control_mux2 ,  rs , rt , rd3 , rd4 , reg_write_exe, reg_write_mem );

/////**** rs and rt come from pipeline register 2 , rd3 come  from pipeline register3 , rd4 from pipeline register 4 .  *****/////////

/////**** reg_write_exe is reg write signal stored in pipelined register 3 and the same for  reg_write_mem   *****////////////

/////**** control_mux1 is register in top . control_mux2 is register below. *****//////

output reg [1:0] control_mux1 , control_mux2;

input [4:0]  rs , rt , rd3 , rd4 ;

input reg_write_exe , reg_write_mem ;

always @ ( rs ,rt , rd3 , rd4 , reg_write_exe , reg_write_mem )
begin
if(reg_write_mem)
begin
	if((rs==rd4) &&(rd4!=0))
	begin
		control_mux1 <= 2'b01 ;
	end
	else
	begin control_mux1 <= 2'b00 ; end 
	if((rt==rd4) &&(rd4!=0))
	begin
		control_mux2 <= 2'b01;
	end
	else
	begin control_mux2 <= 2'b00 ; end 
end

if(reg_write_exe)
begin
	if((rs==rd3) &&(rd3!=0))
	begin
		control_mux1 <= 2'b10 ;
	end
	else if(!(rs==rd4))
	begin control_mux1 <= 2'b00 ; end 
	if((rt==rd3) &&(rd3!=0))
	begin
		control_mux2 <= 2'b10;
	end
	else if(!(rt==rd4))
	begin control_mux2 <= 2'b00 ; end 
end

else
	begin
		control_mux1 <= 2'b00 ;
		control_mux2 <= 2'b00 ;
	end

end


endmodule





/////////////////************** Test Bench for forwarding unit         *********//////////



module testforward ;


reg [4:0] rs , rt , rd3 , rd4 ;

reg reg_write_exe , reg_write_mem ;

wire [1:0] control_mux1 , control_mux2;

Forwarding_Unit F ( control_mux1 , control_mux2 ,  rs , rt , rd3 , rd4 , reg_write_exe, reg_write_mem );

initial


begin


reg_write_exe = 0;
reg_write_mem = 1;

rs = 5'b 10100;
rt = 5'b 10101;
rd3 = 5'b 10100;
rd4 = 5'b10101;   

# 10

reg_write_exe = 1 ;
reg_write_mem = 1;
rs = 5'b 10101;
rt = 5'b 10101;   
rd3 = 5'b 10101;
rd4 = 5'b10101;   


#10

reg_write_exe = 0;
reg_write_mem = 0;
rs = 5'b10101;
rt = 5'b10101;   
rd3 = 5'b10000;
rd4 = 5'b10100; 




end





endmodule
