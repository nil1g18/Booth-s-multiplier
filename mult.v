`include "config.v"

module mult #(parameter N_LEN = 8)(
	output reg [(2*N_LEN)-1:0] Result,
	output reg [2:0] Q_out,
	input Request, Done,
	input [N_LEN-1:0] op1, op2,
	input add_s, sub_s, ashift_s, 
	input Clock, nReset
	);	
			
//for multiplication
reg signed [(2*N_LEN):0] regs;	

//input buffer
reg signed[N_LEN-1:0] op1_buff;

//ALU variables (signed)
reg signed [N_LEN-1:0] b1, alu_out;

//Registers			
always @(posedge Clock, negedge nReset)
	if(!nReset)
		begin	
			regs <= 0;
			op1_buff <= 0;
		end
	else
		begin
			//prep inputs
			if (Request & Done) begin
				regs[0] <= 0;
				regs[N_LEN:1] <= op2;
				regs[2*N_LEN:N_LEN+1] <= 0;
				op1_buff <= op1;
			end
		
			//arithmetic shift right
			if (ashift_s) regs <= regs >>> 1;
			
			//add/sub
			if (add_s | sub_s) regs[2*N_LEN:N_LEN+1] <= alu_out;
		end
		
//ALU
always @(*)
begin
	//2s complement conversion
	if (sub_s) b1 = ~op1_buff + 1'b1;
	else b1 = op1_buff;
	
	alu_out = regs[2*N_LEN:N_LEN+1] + b1 ;
end

//Output
always @(*)
begin
	Result = regs [(2*N_LEN):1];
	Q_out = regs [2:0];
end
	
endmodule
