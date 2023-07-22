//Design of Data Memory using verilog arrays

`timescale 1ns / 1ps

module data_mem(clk, we, data_DM, add_DM, out_DM);

input clk;
input we;
input [31:0] data_DM;
input [11:0] add_DM;
output [31:0] out_DM;

reg [31:0] out_DM;

reg [31:0] mem [31:0];

always@(posedge clk)
begin
	if (we == 1) begin
	mem[add_DM] = data_DM;  //Storing the data in the memory
	end
	
	else if (we == 0) begin
	out_DM = mem[add_DM];  //Accessing the data from the memory
	end
end
endmodule

//TESTBENCH of Data Memory

`timescale 1ns / 1ps


module data_mem_tb();

reg clk;
reg we;
reg [31:0] data_DM;
reg [11:0] add_DM;
wire [31:0] out_DM;

// Instantiation of the module data memory
data_mem d (.clk(clk), .we(we), .data_DM(data_DM), .add_DM(add_DM), .out_DM(out_DM));


initial
begin
	clk <= 0;
	we <= 0;
	data_DM <= 32'h00000000;
	add_DM <= 12'h000;
end

//clock Generation
always #5 clk = ~clk;

//Address Setup
always #60 add_DM = add_DM + 12'h001;
//stimulus
initial 
begin
	#5 we <= 1;
	#5 data_DM <= 32'h0d1f;
	#40 we <= 0;

	#40 we <= 1;
	#5 data_DM <= 32'h1000;
	#40 we <= 0;
end
endmodule




