`include "config.v"

module boothsmult_test; 

parameter N_LEN = 8;

wire [(2*N_LEN)-1:0] Result;
wire Done;
reg signed [N_LEN-1:0] op1, op2;
reg Request;
reg Clock, nReset;

reg signed [(2*N_LEN)-1:0] expected_result = 0;
integer mistakes = 0;

boothsmult #(.N_LEN(N_LEN)) b0 (.Result(Result),
	.Done(Done),
	.op1(op1), .op2(op2),
	.Request(Request),
	.Clock(Clock), .nReset(nReset)
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

for(integer i = 0; i < 10; i = i+1) begin
	op1 = $urandom_range(0,(2**N_LEN)-1);
	op2 = $urandom_range(0,(2**N_LEN)-1);

	#100 Request = 1; expected_result = op1*op2;
	#100 Request = 0;

	#100 while(!Done)
	#100;
	if ( Result != expected_result) mistakes = mistakes + 1;
end

#100 $display("Mistakes : %d",mistakes);

#100 $stop;
end

always
begin
	#50 Clock = ~Clock;
end



endmodule
