//verilog code to realise a D FlipFlop

`timescale 1ns / 1ps

module D_FF(D,clk,Q,Qbar);
input D,clk;		
output Q,Qbar;		
wire D,clk;		
reg Q,Qbar;


always@(posedge clk)	//Positive edge triggering
begin
    //Non blocking assignment
	 Q<=D;		
	 Qbar<=~D;	
end
endmodule
 
//Testbench code of D Flipflop

`timescale 1ns / 1ps

module D_FF_TB();

reg D,clk;		
wire Q,Qbar;		

// Instantiantiation of the D_FF module 
D_FF d (.D(D), .clk(clk), .Q(Q), .Qbar(Qbar));

// initialisation of D & clock to avoid the storing of garbage values
initial
begin
	clk = 0;
	D=0;
end

//CLOCK SETUP
always 
#10 
clk = ~clk;

//STIMULUS
initial 
begin 
#20 D = 1'b1; 
#20 D = 1'b0;
end
endmodule

