//Verilog code to realise a Program Counter in CPU

`timescale 1ns / 1ps

module PC(clock, ldPC, PCinc, add, execadd);
input clock;
input ldPC;
input PCinc;
input [11:0] add;
output [11:0] execadd;

reg [11:0] execadd;
reg [11:0] temp;

always@( posedge clock)
begin
	if (ldPC == 0 && PCinc == 0) 
	begin
	temp <= 12'h000;
	end
	else if (ldPC == 1 && PCinc == 0 )//Load signal of Program counter is high...assign the address to temp 
	begin
	temp <= add;
	end
	else if (ldPC == 0 && PCinc == 1 )//Increment signal of PC is high ...update the temp variable 
	begin
	temp <= temp + 12'h001;
	end
	else begin
	temp <= temp;
	end
	execadd <= temp;
end
endmodule
