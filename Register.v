//Program to realise a 16bit Register 
 
`timescale 1ns / 1ps
module Reg(CLK, LD, DIN, DOUT);
input CLK;
input LD;
input [15:0] DIN;
output [15:0] DOUT;

reg [15:0] DOUT;
reg [15:0] temp;

always@(CLK,LD)
begin
	@(posedge CLK) //Positive triggering
	begin
		if (LD == 1)//Loading the data into the register
		 begin
		DOUT <= DIN;
		temp <= DIN;
		end

		else if (LD == 0) //Retrieving the data from register
		begin
		DOUT <= temp;
		end
	end
end
endmodule

//Testbench code of a register

`timescale 1ns / 1ps

module Reg_TB();

reg CLK;
reg LD;
reg [15:0] DIN;
wire [15:0] DOUT;

// Instantiation of the module Reg

Reg R (.CLK(CLK), .LD(LD), .DIN(DIN), .DOUT(DOUT));

// Initial stimulus
initial
begin
	CLK <= 1'b0;
	LD <= 0;
	DIN <= 16'h0000;
end

// CLOCK SETUP

always #10 CLK = ~CLK;

// Stimilus
initial
begin
	#25 LD = 1;
	DIN = 16'hefef;
	
	#25 LD = 0;
	DIN = 16'hffff;

	#25 LD = 1;
end
endmodule
