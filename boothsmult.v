`include "config.v"

module boothsmult #(parameter N_LEN = 8)(
	output [(2*N_LEN)-1:0] Result,
	output Done,
	input [N_LEN-1:0] op1, op2,
	input Request,
	input Clock, nReset
	);	

//control signals
wire add_s, sub_s, ashift_s;					
wire [2:0] Q;

//mult signalls

control #(.N_LEN(N_LEN)) c0 (.add_s(add_s), 
                            .sub_s(sub_s), 
                            .ashift_s(ashift_s), 
                            .Done(Done), 
                            .Request(Request), 
                            .Q(Q), 
                            .Clock(Clock), 
                            .nReset(nReset));

mult #(.N_LEN(N_LEN)) m0 (.Result(Result), 
                            .Q_out(Q), 
                            .Request(Request), 
                            .Done(Done), 
                            .op1(op1), 
                            .op2(op2), 
                            .add_s(add_s), 
                            .sub_s(sub_s), 
                            .ashift_s(ashift_s), 
                            .Clock(Clock), 
                            .nReset(nReset));

endmodule
