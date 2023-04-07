`include "config.sv"

module boothsmult (
	output [(2*`N_BIT)-1:0] Result,
	output Done,
	input [`N_BIT-1:0] op1, op2,
	input Request,
	input Clock, nReset
	);
	
timeunit 1ns; timeprecision 10ps;	

//control signals
wire add_s, sub_s, ashift_s;					
wire [2:0] Q;

//mult signalls

control c0 (.add_s, .sub_s, .ashift_s, .Done, .Request, .Q, .Clock, .nReset);

mult m0 (.Result, .Q_out(Q), .Request, .Done, .op1, .op2, .add_s, .sub_s, .ashift_s, .Clock, .nReset);

endmodule