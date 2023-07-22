//Verilog code to realise a multiplexer

`timescale 1ns / 1ps

module mux_A (CLK,I1,I2,SEL,OUTA);

input CLK;
input [31:0] I1; //Output of ALU
input [15:0] I2; //Immediate value
input SEL;
output reg[31:0] OUTA;

reg [31:0] outA;

always@(posedge CLK)
begin
	if (SEL == 1 ) 
	begin
	OUTA <= I1;
	end
	else if (SEL == 0)
	 begin
	OUTA <= {16'b0000000000000000,I2};
	end
end
endmodule
