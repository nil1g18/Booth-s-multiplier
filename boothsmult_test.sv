`include "config.sv"

module boothsmult_test; 

timeunit 1ns; timeprecision 10ps;	

wire [(2*`N_BIT)-1:0] Result;
wire Done;
logic signed [`N_BIT-1:0] op1, op2;
logic Request;
logic Clock, nReset;

logic signed [(2*`N_BIT)-1:0] expected_result = 0;
int mistakes = 0;

boothsmult b0 (.Result,
	.Done,
	.op1, .op2,
	.Request,
	.Clock, .nReset
	);

initial
begin
//Starting
Clock = 0;
nReset = 0;
op1 = 0;
op2 = 0;
Request = 0;

#50 nReset = 1;
#50

//Multiple results test

for(int i = 0; i < 10; i++) begin
op1 = $urandom_range(0,(2**`N_BIT)-1);
op2 = $urandom_range(0,(2**`N_BIT)-1);

#100 Request = 1; expected_result = op1*op2;
#100 Request = 0;

#100 while(!Done)
	#100;

assert ( Result == expected_result)
	else
		mistakes = mistakes + 1;
end

#100 $display("Mistakes : %d",mistakes);

#100 $stop;
end

always
begin
	#50 Clock = ~Clock;
end



endmodule