//Design of ALU with condition flags

`timescale 1ns / 1ps
 
//Fields of INSTRUCTION REGISTER
`define opcode    IR[31:27]   // OPCODE SIZE - 5bit
`define rdst      IR[26:22]  // Destination Register - 5bit
`define rsrc1     IR[21:17]  // Address of first operand...size - 5bit
`define imm_mode  IR[16]     // Determines the addressing mode...MODE - 0 = Register addresssing mode...MODE - 1 = Immediate addressing mode..size = 1bit
`define rsrc2     IR[15:11]  //Address of second operand...size = 5bit
`define isrc      IR[15:0]   // Specifies the operand value in immediate addressing mode when mode = 1...size = 16bit
 
//INSTRUCTION SET

//MOVE OPERATIONS
`define movsgpr        5'b00000   //useful while doing multiplication operation
`define mov            5'b00001   //To copy the content of one register to another


//ARTHIMETIC OPERATIONS
`define add            5'b00010
`define sub            5'b00011
`define mul            5'b00100
`define div            5'b00101

//LOGICAL OPERATIONS
`define ror            5'b00110
`define rand           5'b00111
`define rxor           5'b01000
`define rxnor          5'b01001
`define rnand          5'b01010
`define rnor           5'b01011
`define rnot           5'b01100

module ALU();
reg [31:0] IR;            //Instruction Register of size 32-bit
                          // instruction register  <--ir[31:27]--><--ir[26:22]--><--ir[21:17]--><--ir[16]--><--ir[15:11]--><--ir[10:0]-->
                          //fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  rsrc2 --><--unused  -->             
                          //fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_data      -->      
 
reg [15:0] GPR [31:0] ;  //  32 General Purpose Registers of size 16-bit... from GPR[0] to GPR[31]...
 
 
 
reg [15:0] SGPR ;     //To store MSB of multiplication
 
reg [31:0] mul_res;  // To store the result of multiplication
 
 always@(*)
begin
case(`opcode)

`movsgpr: begin
   GPR[`rdst] = SGPR;   
end
 

`mov : begin
   if(`imm_mode)
        GPR[`rdst]  = `isrc;
   else
       GPR[`rdst]   = GPR[`rsrc1];
end
 
//ADDITION OPERATION
`add : begin
      if(`imm_mode)
        GPR[`rdst]   = GPR[`rsrc1] + `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] + GPR[`rsrc2];
end
 
//SUBTRACTION OPERATION
 
`sub : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] - `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] - GPR[`rsrc2];
end
 
//MULTIPLICATION OPERATION
 
`mul : begin
      if(`imm_mode)
        mul_res   = GPR[`rsrc1] * `isrc;
     else
        mul_res   = GPR[`rsrc1] * GPR[`rsrc2];
        
     GPR[`rdst]   =  mul_res[15:0];
     SGPR         =  mul_res[31:16];
end

//DIVISION OPERATION
`div : begin
     if(`imm_mode)
     GPR[`rdst] = GPR[`rsrc1]/`isrc;
     else
      GPR[`rdst] = GPR[`rsrc1]/GPR[`rsrc2];
 end

//BITWISE OR OPERATION
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



//Logic for condition flags
reg sign = 0, zero = 0, overflow = 0, carry = 0;//condition flags
reg [16:0] temp_sum; //Temporarily storing the result of Addition 
always@(*)
begin
 
//SIGN BIT FLAG
if(`opcode == `mul)
  sign = SGPR[15];  //For multiplication result
else
  sign = GPR[`rdst][15]; // For either addition or subtraction result
 
//CARRY BIT FLAG
 
if(`opcode == `add)
   begin
      if(`imm_mode)
         begin
         temp_sum = GPR[`rsrc1] + `isrc;
         carry    = temp_sum[16]; 
         end
      else
         begin
         temp_sum = GPR[`rsrc1] + GPR[`rsrc2];
         carry    = temp_sum[16]; 
         end   end
      else
      begin
        carry  = 1'b0;
      end
 
 //ZERO BIT FLAG
if(`opcode == `mul)
  zero =  ~((|SGPR[15:0]) | (|GPR[`rdst]));
else
  zero =  ~(|GPR[`rdst]); 
 
 
//OVERFLOW BIT FLAG 
 
if(`opcode == `add)
     begin
     if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & ~IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & IR[15] & ~GPR[`rdst][15]) );
     else
         overflow = ( (~GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & GPR[`rsrc2][15] & ~GPR[`rdst][15]));
     end
     else if(`opcode == `sub)
     begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & ~IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & ~GPR[`rdst][15]));
     end 
     else
     begin
     overflow = 1'b0;
     end
 
end
endmodule

//TestBench of ALU

`timescale 1ns / 1ps

module ALU_tb();


ALU dut();//Instantiating the module ALU 
integer i = 0;
initial begin
for(i=0; i<32; i=i+1)
begin
dut.GPR[i]=2; //Initialising all GPR's to the value of 2
end
end

initial begin

//Immediate move operation
dut.IR = 0;
dut.`imm_mode = 1;
dut.`opcode = 1;
dut.`rdst = 4;///gpr[4]
dut.`isrc = 55;
#10;
$display("OP:MOVI Rdst:%0d  imm_data:%0d",dut.GPR[4],dut.`isrc  );
$display("-----------------------------------------------------------------");
 
 //Register move operation
dut.IR = 0;
dut.`imm_mode = 0;
dut.`opcode = 1;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
#10;
$display("OP:MOV Rdst:%0d  Rsrc1:%0d",dut.GPR[4],dut.GPR[7] );
$display("-----------------------------------------------------------------");

//Register add operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.GPR[0] = 7;
dut.GPR[1] = 14;
dut.`imm_mode = 0;
dut.`opcode = 2;
dut.`rsrc1 = 0; //GPR[0] = 7
dut.`rsrc2 = 1; //GPR[1] = 14
dut.`rdst = 2;//GPR[2];
#10;
$display("OP:ADD Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.GPR[1], dut.GPR[2]);
$display("-----------------------------------------------------------------");

//Immediate add operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.`opcode = 2;
dut.`rsrc1 = 0;
dut.`rdst  = 2;
dut.`isrc = 4;
#10;
$display("OP:ADI Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.`isrc, dut.GPR[2]);
$display("-----------------------------------------------------------------");

//Register sub operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 0;
dut.GPR[3] = 5;
dut.GPR[4] = 1;
dut.`opcode = 3;
dut.`rsrc1 = 3;
dut.`rsrc2 = 4;
dut.`rdst = 5;
#10;
$display("OP:SUB Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[3], dut.GPR[4], dut.GPR[5]);
$display("-----------------------------------------------------------------");

//Immediate sub operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.GPR[3] = 5;
dut.`opcode = 3;
dut.`rsrc1 = 3;
dut.`isrc = 4;
dut.`rdst = 5;
#10;
$display("OP:SUBI Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[3], dut.`isrc, dut.GPR[5]);
$display("-----------------------------------------------------------------");

//Register mul operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 0;
dut.GPR[6] = 5;
dut.GPR[7] = 9;
dut.`opcode = 4;
dut.`rsrc1 = 6;
dut.`rsrc2 = 7;
dut.`rdst = 8;
#10;
$display("OP:MUL Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d Rdst2:%0d",dut.GPR[6], dut.GPR[7], dut.GPR[8], dut.SGPR);
$display("-----------------------------------------------------------------");

//Immediate mul operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.GPR[7] = 9;
dut.`opcode = 4;
dut.`rsrc1 = 7;
dut.`isrc = 4;
dut.`rdst = 8;
#10;
$display("OP:MULI Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d Rdst2:%0d",dut.GPR[7], dut.`isrc, dut.GPR[8], dut.SGPR);
$display("-----------------------------------------------------------------");

//Register div operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 0;
dut.GPR[9] = 5;
dut.GPR[10] = 9;
dut.`opcode = 5;
dut.`rsrc1 = 9;
dut.`rsrc2 = 10;
dut.`rdst = 11;
#10;
$display("OP:DIV Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d ",dut.GPR[9], dut.GPR[10], dut.GPR[11]);
$display("-----------------------------------------------------------------");

//Immediate div operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.GPR[9] = 5;
dut.`opcode = 5;
dut.`rsrc1 = 9;
dut.`isrc = 2;
dut.`rdst = 11;
#10;
$display("OP:DIVI Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d ",dut.GPR[9], dut.`isrc, dut.GPR[11]);
$display("-----------------------------------------------------------------");

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

//ZERO BIT FLAG
dut.IR  = 0;
dut.GPR[0] = 0;
dut.GPR[1] = 0; 
dut.`imm_mode = 0;
dut.`rsrc1 = 0;//gpr[0]
dut.`rsrc2 = 1;//gpr[1]
dut.`opcode = 2;
dut.`rdst = 2;
#10;
$display("OP:Zero Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.GPR[1], dut.GPR[2] );
$display("-----------------------------------------------------------------");
 
//SIGN FLAG
dut.IR = 0;
dut.GPR[0] = 16'h8000; ////1000_0000_0000_0000
dut.GPR[1] = 0; 
dut.`imm_mode = 0;
dut.`rsrc1 = 0;//gpr[0]
dut.`rsrc2 = 1;//gpr[1]
dut.`opcode = 2;
dut.`rdst = 2;
#10;
$display("OP:Sign Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.GPR[1], dut.GPR[2] );
$display("-----------------------------------------------------------------");
 
//CARRY FLAG
dut.IR = 0;
dut.GPR[0] = 16'h8000; /////1000_0000_0000_0000   <0
dut.GPR[1] = 16'h8002; /////1000_0000_0000_0010   <0
dut.`imm_mode = 0;
dut.`rsrc1 = 0;//gpr[0]
dut.`rsrc2 = 1;//gpr[1]
dut.`opcode = 2;
dut.`rdst = 2;    //////// 0000_0000_0000_0010  >0
#10;
 
$display("OP:Carry & Overflow Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[0], dut.GPR[1], dut.GPR[2] );
$display("-----------------------------------------------------------------");

#20;
$finish;
end
 
endmodule


