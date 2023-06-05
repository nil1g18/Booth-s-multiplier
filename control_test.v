`include "config.v"

module control_test;

wire add_s, sub_s, ashift_s;
wire Done;  //Check1
reg Request;				
reg [2:0] Q;
reg Clock, nReset;

control c0 (.add_s(add_s), 
            .sub_s(sub_s),
            .ashift_s(ashift_s),
            .Done(Done),
            .Request(Request),
            .Q(Q),
            .Clock(Clock),
            .nReset(nReset));

initial
begin
//Starting
Clock = 0;
nReset = 0;
Request = 0;
Q = 0;

#50 nReset = 1;

#50 

//Check 1: Done signal
#100 if (Done != 1) $display("Check 1 failed.");
		
//Check 2: controller counter
#500 
Request = 1;
#100 Request = 0;		

//Check 3: ADD SUB ASHIFT
#1000 Request = 1;
	 Q = 3'b100;
#100 Request = 0;

#100 
#100 Q = 3'b110;
#100 Q = 3'b011;
#100 Q = 3'b001;
#100 Q = 3'b000;

#1500 $finish;

end

always
begin
	#50 Clock = ~Clock;
end


endmodule
