//Designing a 2:1 Multiplexer

`timescale 1ns / 1ps

module mux_B(CLK,I1,I2,SEL,OUTB);

input CLK;
input [4:0] I1;  //Address of current instruction
input [4:0] I2;  //Address of next instruction
input SEL;
output [4:0] OUTB;
reg [4:0] OUTB;

always@(posedge CLK)
begin
	if ( SEL == 1 ) begin
	OUTB <= I1;
	end
	else if (SEL == 0) begin
	OUTB <= I2;
	end
end
endmodule


