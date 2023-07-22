//The purpose to design this module is to understand how the CPU decodes the addresses of source and destination registers
//design code of 3:8 decoder

`timescale 1ns / 1ps
module decoder3to8(IN,EN,OUT);
input [2:0] IN;
input  EN;
output reg 	[7:0] OUT;
  
always @( IN or EN)
	begin

      if (EN) 
        begin
          OUT = 8'd0;
          case (IN)
              3'b000: OUT[0]=1'b1;
              3'b001: OUT[1]=1'b1;
              3'b010: OUT[2]=1'b1;
              3'b011: OUT[3]=1'b1;
              3'b100: OUT[4]=1'b1;
              3'b101: OUT[5]=1'b1;
              3'b110: OUT[6]=1'b1;
              3'b111: OUT[7]=1'b1;
              default: OUT=8'd0;
          endcase
      end
else 
OUT = 8'd0;
end
endmodule

//Testbench code of a 3:8 decoder

`timescale 1ns / 1ps


module decoder3to8_tb();
reg EN;
reg [2:0] IN;
integer i;
wire [7:0] OUT;

decoder3to8 d(IN,EN,OUT);

initial begin  
 $monitor( "EN=%b, IN=%d, OUT=%b ", EN, IN, OUT);
   for ( i=0; i<16; i=i+1) 
        begin
           {EN,IN}  = i;
            #1;
        end
end
endmodule