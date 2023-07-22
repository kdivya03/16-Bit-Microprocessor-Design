//Design of Program Memory

`timescale 1ns / 1ps

module inst_mem();
reg clk = 0, wea = 0;
reg [10:0] addr;
reg [31:0] din;
wire [31:0] dout;
 
reg [31:0] mem [31:0];// Program Memory having 32 addresses of size 32-bit
  
initial begin
$readmemb("inst.mem",mem);
end
 
 
reg [31:0] IR;//Instruction Register
 
 //clock generation
always #5 clk = ~clk;
 
integer count = 0;//Default size of integer datatype is 32-bit 
integer delay = 0;//To maintain the delay btw reading of intsructions 
 
always@(posedge clk)
begin
if(delay < 4)
begin
delay <= delay + 1;
end
else
begin
count <= count + 1;//acting as a Program counter & updates it's value after every 4 clock cycles
delay <= 0;
end
end

//Reading an instruction after every 4 clock cycles
always@(*)
begin
IR = mem[count];
end
endmodule

