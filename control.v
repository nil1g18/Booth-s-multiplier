`include "config.v"

module control #(parameter N_LEN = 8)(
	output reg add_s, sub_s, ashift_s, 	//Control signals
	output reg Done, 			   	//Interface signals
	input Request,					
	input [2:0] Q ,				//Q1 Q0 and Q-1 (potentially need to pre-read the bits to save a clock cycle)
	input Clock, nReset				//FF
	);
	
localparam IDLE = 3'd0;
localparam PREP = 3'd1;
localparam ADD = 3'd2;
localparam SUB = 3'd3;
localparam ASHIFT = 3'd4;

reg [2:0] state;

reg unsigned [$clog2(N_LEN)-1:0] counter;  //Number of ashifts = N_LEN

//FSM
always @(posedge Clock, negedge nReset)
	if(!nReset)
		begin
            counter <= 0;
		end
	else
		begin
			case(state)
				IDLE: 	begin
					if (Request) state <= PREP;
					counter <= 0;
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
always @ (add_s, sub_s, ashift_s, Done, state)
begin
	add_s = (state == ADD);
	sub_s = (state == SUB);
	ashift_s = (state == ASHIFT);
	Done = (state == IDLE);
end
		
endmodule
