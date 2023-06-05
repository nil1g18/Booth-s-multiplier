`include "config.v"

module mult_test; 

parameter N_LEN = 8;	
	
reg Request,Done;
reg signed [N_LEN-1:0] op1, op2;
reg add_s, sub_s, ashift_s; 
reg Clock, nReset;
	
wire [(2*N_LEN)-1:0] Result;
wire [2:0] Q_out;	

mult #(.N_LEN(N_LEN)) m0 (.Result(Result),
			 .Q_out(Q_out), 
			.Request(Request), 
			.Done(Done), 
			.op1(op1), 	
			.op2(op2), 
			.add_s(add_s), 
			.sub_s(sub_s), 
			.ashift_s(ashift_s), 
			.Clock(Clock), 
			.nReset(nReset));	

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
	//sv assert properties doesnt work
		
#100 add_s = 1; 
	if (m0.alu_out != m0.regs[2*`N_BIT:`N_BIT+1] + op1)
        $display("alu failed.");

	//sv assert property doesnt work

#100 add_s = 0; sub_s = 1;

#100 sub_s = 0; ashift_s = 1;

#100 $stop;

end

always
	#50 Clock = ~Clock;
			
endmodule
