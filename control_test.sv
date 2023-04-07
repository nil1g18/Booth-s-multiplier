`include "config.sv"

module control_test;

timeunit 1ns; timeprecision 10ps;

wire add_s, sub_s, ashift_s;
wire Done;  //Check1
logic Request;				
logic [2:0] Q;
logic Clock, nReset;

control c0 (.add_s, .sub_s, .ashift_s, .Done, .Request, .Q, .Clock, .nReset);

initial
begin
//Starting
Clock = 0;
nReset = 0;
Request = 0;
Q = '0;

#50 nReset = 1;

#50 

//Check 1: Done signal
#100 assert (Done == 1)
		else 
			$error("Check 1 failed.");
		
//Check 2: controller counter
#500 
Request = 1;
#100 Request = 0;

	assert 
		property (@(posedge Clock) Request |=> ##(`N_BIT+1) Done)
		else
			$error("Check 2 failed.");		

//Check 3: ADD SUB ASHIFT
#1000 Request = 1;
	 Q = 3'b100;
#100 Request = 0;

#100 
#100 Q = 3'b110;
#100 Q = 3'b011;
#100 Q = 3'b001;
#100 Q = 3'b000;

#1500 $stop;

end

always
begin
	#50 Clock = ~Clock;
end


endmodule