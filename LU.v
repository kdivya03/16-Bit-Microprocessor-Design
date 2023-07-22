//Design of Logical Unit

`timescale 1ns / 1ps

//Fields of INSTRUCTION REGISTER
`define opcode    IR[31:27]   // OPCODE SIZE - 5bit
`define rdst      IR[26:22]  // Destination Register - 5bit
`define rsrc1     IR[21:17]  // Address of first operand...size - 5bit
`define imm_mode  IR[16]     // Determines the addressing mode...MODE - 0 = Register addresssing mode...MODE - 1 = Immediate addressing mode..size = 1bit
`define rsrc2     IR[15:11]  //Address of second operand...size = 5bit
`define isrc      IR[15:0]   // Specifies the operand value in immediate addressing mode when mode = 1...size = 16bit
 
//INSTRUCTION SET

//LOGICAL OPERATIONS
`define ror            5'b00110
`define rand           5'b00111
`define rxor           5'b01000
`define rxnor          5'b01001
`define rnand          5'b01010
`define rnor           5'b01011
`define rnot           5'b01100


module LU();

reg [31:0] IR;            //Instruction Register of size 32-bit
                          // instruction register  <--ir[31:27]--><--ir[26:22]--><--ir[21:17]--><--ir[16]--><--ir[15:11]--><--ir[10:0]-->
                          //fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  rsrc2 --><--unused  -->             
                          //fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_data      -->      
 
reg [15:0] GPR [31:0] ;  // 32 General Purpose Registers of size 16-bit... from GPR[0] to GPR[31]...
 
 always@(*)
begin
case(`opcode)
//Bitwise OR Operation
 
`ror : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] | `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] | GPR[`rsrc2];
end
 
//Bitwise AND Operation
 
`rand : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] & `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] & GPR[`rsrc2];
end
 
//Bitwise XOR Operation
 
`rxor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ^ `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] ^ GPR[`rsrc2];
end
 
//Bitwise XNOR Operation
 
`rxnor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ~^ `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] ~^ GPR[`rsrc2];
end
 
//Bitwise NAND Operation
 
`rnand : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] & `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] & GPR[`rsrc2]);
end
 
//Bitwise NOR Operation
`rnor : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] | `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] | GPR[`rsrc2]);
end
 
//NOT OPERATION
 
`rnot : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(`isrc);
     else
        GPR[`rdst]   = ~(GPR[`rsrc1]);
end        
endcase
end
endmodule


//TestBench of LU

`timescale 1ns / 1ps


module LU_TB();

integer i = 0;

LU dut(); //Instantiation of the module LU

initial begin
for(i=0; i<32; i=i+1)
begin
dut.GPR[i]=2; //Initialising all GPR's to the value of 2
end
end
initial begin
//Register mode & Logical OR
dut.IR = 0;
dut.GPR[12] = 5;
dut.GPR[13] = 10;
dut.`imm_mode = 0;
dut.`opcode = 6;
dut.`rdst = 14;
dut.`rsrc1 = 12;
dut.`rsrc2 = 13;
#10;
$display("OP:OR   Rsrc1:%8b Rsrc2:%8b Rdst:%8b",dut.GPR[12],dut.GPR[13],dut.GPR[14] );
$display("-----------------------------------------------------------------");


//Immediate mode & Logical OR 
dut.IR = 0;
dut.GPR[12] = 5;
dut.`imm_mode = 1;
dut.`opcode = 6;
dut.`rdst = 14;
dut.`rsrc1 = 12;
dut.`isrc = 56;
#10;
$display("OP:ORI  Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[12],dut.`isrc,dut.GPR[14] );
$display("-----------------------------------------------------------------");


//Register mode & Logical AND
dut.IR = 0;
dut.GPR[15] = 5;
dut.GPR[16] = 10;
dut.`imm_mode = 0;
dut.`opcode = 7;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`rsrc2 = 16;
#10;
$display("OP:AND Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.GPR[16],dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Immediate mode & Logical AND
dut.IR = 0;
dut.GPR[15] = 5;
dut.`imm_mode = 1;
dut.`opcode = 7;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`isrc = 56;
#10;
$display("OP:ANDI Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.`isrc,dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Register mode & Logical XOR
dut.IR = 0;
dut.GPR[15] = 5;
dut.GPR[16] = 10;
dut.`imm_mode = 0;
dut.`opcode = 8;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`rsrc2 = 16;
#10;
$display("OP:XOR Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.GPR[16],dut.GPR[17], );
$display("-----------------------------------------------------------------");

 //Immediate mode & Logical XOR
dut.IR = 0;
dut.GPR[15] = 5;
dut.`imm_mode = 1;
dut.`opcode = 8;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`isrc = 56;
#10;
$display("OP:XORI Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.`isrc,dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Register mode & Logical XNOR
dut.IR = 0;
dut.GPR[15] = 5;
dut.GPR[16] = 10;
dut.`imm_mode = 0;
dut.`opcode = 9;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`rsrc2 = 16;
#10;
$display("OP:XNOR Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.GPR[16],dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Immediate mode & Logical XNOR
dut.IR = 0;
dut.GPR[15] = 5;
dut.`imm_mode = 1;
dut.`opcode = 9;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`isrc = 56;
#10;
$display("OP:XNORI Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.`isrc,dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Register mode & Logical NAND
dut.IR = 0;
dut.GPR[15] = 5;
dut.GPR[16] = 10;
dut.`imm_mode = 0;
dut.`opcode = 10;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`rsrc2 = 16;
#10;
$display("OP:NAND Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.GPR[16],dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Immediate mode & Logical NAND
dut.IR = 0;
dut.GPR[15] = 5;
dut.`imm_mode = 1;
dut.`opcode = 10;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`isrc = 56;
#10;
$display("OP:NANDI Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.`isrc,dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Register mode & Logical NOR
dut.IR = 0;
dut.GPR[15] = 5;
dut.GPR[16] = 10;
dut.`imm_mode = 0;
dut.`opcode = 11;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`rsrc2 = 16;
#10;
$display("OP:NOR Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.GPR[16],dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Immediate mode & Logical NOR
dut.IR = 0;
dut.GPR[15] = 5;
dut.`imm_mode = 1;
dut.`opcode = 11;
dut.`rdst = 17;
dut.`rsrc1 = 15;
dut.`isrc = 56;
#10;
$display("OP:NORI Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[15],dut.`isrc,dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Register mode & Logical NOT
dut.IR = 0;
dut.GPR[15] = 5;
dut.GPR[16] = 10;
dut.`imm_mode = 0;
dut.`opcode = 12;
dut.`rdst = 17;
dut.`rsrc1 = 15;
#10;
$display("OP:NOT Rsrc1:%8b   Rdst:%8b",dut.GPR[15],dut.GPR[17], );
$display("-----------------------------------------------------------------");

//Immediate mode & Logical NOT
dut.IR = 0;
dut.GPR[15] = 5;
dut.`imm_mode = 1;
dut.`opcode = 12;
dut.`rdst = 17;
dut.`isrc = 56;
#10;
$display("OP:NOTI  Rsrc2:%8b Rdst:%8b",dut.`isrc,dut.GPR[17], );
$display("-----------------------------------------------------------------");

end
endmodule