`include "config.sv"

module mult (
	output logic [(2*`N_BIT)-1:0] Result,
	output logic [2:0] Q_out,
	input Request, Done,
	input [`N_BIT-1:0] op1, op2,
	input add_s, sub_s, ashift_s, 
	input Clock, nReset
	);
	
timeunit 1ns; timeprecision 10ps;	
			
//for multiplication
logic signed [(2*`N_BIT):0] regs;	

//input buffer
logic signed[`N_BIT-1:0] op1_buff;

//ALU variables (signed)
logic signed [`N_BIT-1:0] B1, alu_out;

//Registers			
always_ff @(posedge Clock, negedge nReset)
	if(!nReset)
		begin	
			regs <= '0;
			op1_buff <= '0;
		end
	else
		begin
			//prep inputs
			if (Request & Done) begin
				regs[0] <= '0;
				regs[`N_BIT:1] <= op2;
				regs[2*`N_BIT:`N_BIT+1] <= '0;
				op1_buff <= op1;
			end
		
			//arithmetic shift right
			if (ashift_s) regs <= regs >>> 1;
			
			//add/sub
			if (add_s | sub_s) regs[2*`N_BIT:`N_BIT+1] <= alu_out;
		end
		
//ALU
always_comb
begin
	//2s complement conversion
	if (sub_s) B1 = ~op1_buff + 1'b1;
	else B1 = op1_buff;
	
	alu_out = regs[2*`N_BIT:`N_BIT+1] + B1 ;
end

//Output
always_comb
begin
	Result = regs [(2*`N_BIT):1];
	Q_out = regs [2:0];
end
	
endmodule