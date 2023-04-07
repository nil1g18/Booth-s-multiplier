`include "config.sv"

module control (
	output logic add_s, sub_s, ashift_s, 	//Control signals
	output logic Done, 			   	//Interface signals
	input Request,					
	input [2:0] Q ,				//Q1 Q0 and Q-1 (potentially need to pre-read the bits to save a clock cycle)
	input Clock, nReset				//FF
	);
	
timeunit 1ns; timeprecision 10ps;
	
enum logic [2:0] {IDLE = 0, PREP = 1, ADD = 2, SUB = 3, ASHIFT = 4} state;

logic unsigned [$clog2(`N_BIT)-1:0] counter;  //Number of loops determined from nBits

//FSM
always_ff @(posedge Clock, negedge nReset)
	if(!nReset)
		begin
		counter <= '0;
		end
	else
		begin
			case(state)
				IDLE: 	begin
						if (Request) state <= PREP;
						counter <= '0;
						end

				PREP:	begin
						if(Q[1] == Q[0]) state <= ASHIFT;
						else 
							if (Q[0]) 	state <= ADD;
							else 		state <= SUB;	
						end
						
				ADD, SUB :	state <= ASHIFT;
				
				ASHIFT:	begin
						if (counter == (`N_BIT-1)) state <= IDLE;
						else
							begin
							counter <= counter + 1;
							if(Q[2] == Q[1]) state <= ASHIFT;
							else 
								if (Q[1]) 	state <= ADD;
								else 		state <= SUB;
							end
						end
				default: state <= IDLE;
			endcase
		end
	
//Output signals	
always_comb		
begin
	add_s = (state == ADD);
	sub_s = (state == SUB);
	ashift_s = (state == ASHIFT);
	Done = (state == IDLE);

end
		
endmodule