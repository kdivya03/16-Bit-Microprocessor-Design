//Program to realise a 4 bit synchronous up counter...Active high enable & synchronous reset.

`timescale 1ns / 1ps

module counter4bit(CLK,RST,EN,OUT);
input CLK,RST,EN;
output [3:0] OUT;
wire CLK,RST,EN;
reg [3:0] OUT;

always@(posedge CLK)//Positive triggering
begin
	if(RST == 1'b1)//Reset is high to make the output to zero
	begin
		OUT <= 4'b0000;
	end
	else 
	if (EN == 1'b1)//Enable signal is high to make the count
	begin
		OUT <= OUT + 4'b0001;
	end
end
endmodule

//Testbench code for 4bit synchronous up counter

`timescale 1ns / 1ps
module counter4bit_tb();
reg CLK,RST,EN;
wire [3:0] OUT;

//Initial stimulus to input signals
initial
begin
	CLK<=1'b0;
	RST<=1'b0;
	EN<=1'b0;
end

// Instantiation of the Counter4bit module

counter4bit c(.CLK(CLK), .RST(RST), .EN(EN), .OUT(OUT));

//clock signal setup with a clock period of 10ns

always #10 CLK = ~CLK;

//stimulus
initial
begin
	#5 RST <= 1;
	#10 EN <= 1;
	
	#10 RST <= 0;
	#10 EN <= 1;

	#300 EN <= 0;

	#10 RST <= 1;
end
endmodule