`include "config.sv"

module mult_test; 

timeunit 1ns; timeprecision 10ps;	
		
logic Request,Done;
logic signed [`N_BIT-1:0] op1, op2;
logic add_s, sub_s, ashift_s; 
logic Clock, nReset;
	
wire [(2*`N_BIT)-1:0] Result;
wire [2:0] Q_out;	

mult m0 (.Result, .Q_out, .Request, .Done, .op1, .op2, .add_s, .sub_s, .ashift_s, .Clock, .nReset);	

initial
begin
//Starting
Clock = 0;
nReset = 0;
op1 = 0;
op2 = 0;
add_s = 0;
sub_s = 0;
ashift_s = 0;
Request = 0;
Done = 0;

#50 nReset = 1;

#50

//Request & Done
op1 = 8'd15;
op2 = 8'd23;

#100 Request = 1;
#100 Request = 0; Done = 1;
#100 Request = 1; Done = 1;
	assert property (@(posedge Clock) Clock |-> (Result[`N_BIT-1:0] == op2) && (m0.op1_buff == op1))
	else
		$error("Prep failed.");
		
#100 add_s = 1; 
	assert (m0.alu_out == m0.regs[2*`N_BIT:`N_BIT+1] + op1)
	else
		$error("alu failed.");

	assert property (@(posedge Clock) Clock |-> (m0.regs[2*`N_BIT:`N_BIT+1] == m0.alu_out))
	else
		$error("alu_out failed.");

#100 add_s = 0; sub_s = 1;

#100 sub_s = 0; ashift_s = 1;

#100 $stop;

end

always
	#50 Clock = ~Clock;
			
endmodule