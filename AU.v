//Design of Arithmetic Unit 

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


module AU();

reg [31:0] IR;            //Instruction Register of size 32-bit
                          // instruction register  <--ir[31:27]--><--ir[26:22]--><--ir[21:17]--><--ir[16]--><--ir[15:11]--><--ir[10:0]-->
                          //fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  rsrc2 --><--unused  -->             
                          //fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_data      -->      
 
reg [15:0] GPR [31:0] ;  // 32 General Purpose Registers of size 16-bit... from GPR[0] to GPR[31]...
 
 
 
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
 
//Addition Operation
`add : begin
      if(`imm_mode)
        GPR[`rdst]   = GPR[`rsrc1] + `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] + GPR[`rsrc2];
end
 
//Subtraction Operation
 
`sub : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] - `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] - GPR[`rsrc2];
end
 
//Multiplication Operation 
 
`mul : begin
      if(`imm_mode)
        mul_res   = GPR[`rsrc1] * `isrc;
     else
        mul_res   = GPR[`rsrc1] * GPR[`rsrc2];
        
     GPR[`rdst]   =  mul_res[15:0];
     SGPR         =  mul_res[31:16];
end

//Division Operation
`div : begin
     if(`imm_mode)
     GPR[`rdst] = GPR[`rsrc1]/`isrc;
     else
      GPR[`rdst] = GPR[`rsrc1]/GPR[`rsrc2];
 end
endcase
end
endmodule 

//TestBench of AU
`timescale 1ns / 1ps

module AU_TB();

integer i = 0;

AU dut(); //Instantiation of the module AU

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
dut.`rdst = 4;///GPR[4]
dut.`isrc = 55;
#10;
$display("OP:MOVI Rdst:%0d  imm_data:%0d",dut.GPR[4],dut.`isrc  );
$display("-----------------------------------------------------------------");
 
 //Register move operation
dut.IR = 0;
dut.`imm_mode = 0;
dut.`opcode = 1;
dut.`rdst = 4;
dut.`rsrc1 = 7;//GPR[7]
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
dut.`rsrc1 = 0;//GPR[0]
dut.`rdst  = 2;//GPR[2]
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
dut.`rsrc1 = 3;//GPR[3]
dut.`rsrc2 = 4;//GPR[4]
dut.`rdst = 5;//GPR[5]
#10;
$display("OP:SUB Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[3], dut.GPR[4], dut.GPR[5]);
$display("-----------------------------------------------------------------");

//Immediate sub operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.GPR[3] = 5;
dut.`opcode = 3;
dut.`rsrc1 = 3;//GPR[3]
dut.`isrc = 4;
dut.`rdst = 5;//GPR[5]
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
dut.`rsrc1 = 6;//GPR[6]
dut.`rsrc2 = 7;//GPR[7]
dut.`rdst = 8;//GPR[8]
#10;
$display("OP:MUL Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d Rdst2:%0d",dut.GPR[6], dut.GPR[7], dut.GPR[8], dut.SGPR);
$display("-----------------------------------------------------------------");

//Immediate mul operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.GPR[7] = 9;
dut.`opcode = 4;
dut.`rsrc1 = 7;//GPR[7]
dut.`isrc = 4;
dut.`rdst = 8;//GPR[8]
#10;
$display("OP:MUL Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d Rdst2:%0d",dut.GPR[7], dut.`isrc, dut.GPR[8], dut.SGPR);
$display("-----------------------------------------------------------------");

//Register div operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 0;
dut.GPR[9] = 5;
dut.GPR[10] = 9;
dut.`opcode = 5;
dut.`rsrc1 = 9;//GPR[9]
dut.`rsrc2 = 10;//GPR[10]
dut.`rdst = 11;//GPR[11]
#10;
$display("OP:DIV Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d ",dut.GPR[9], dut.GPR[10], dut.GPR[11]);
$display("-----------------------------------------------------------------");

//Immediate div operation
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.GPR[9] = 5;
dut.`opcode = 5;
dut.`rsrc1 = 9;//GPR[9]
dut.`isrc = 2;
dut.`rdst = 11;//GPR[11]
#10;
$display("OP:DIVI Rsrc1:%0d  Rsrc2:%0d Rdst1:%0d ",dut.GPR[9], dut.`isrc, dut.GPR[11]);
$display("-----------------------------------------------------------------");


end
endmodule

