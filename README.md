# 16 Bit Microprocessor Design

APPROACH

Designing the constituent components was the first step in achieving a 16 bit CPU design.The components were as follows:

1.Instruction Register  
2.Arithmetic Unit  
3.Logical Unit  
4.ALU  
5.Data Memory  
6.Instruction Memory  
7.Program Counter  
8.Control Unit   
9.CPU   


INSTRUCTION SET  

Generally, two types of instruction sets used in digital computers.  
RISC - Reduced Instruction Set Architecture   
CISC - Complex Instruction Set Architecture   
We followed the RISC architecture to design the microprocessor.   

This CPU supports 32bit instructions.The type of instruction is identified by using OPCODE.Since OPCODE controls the activity,the OPCODE is used as described below.OPCODE size is 5 bit. 

MOVE OPERATIONS     
00000 - movsgpr (useful while doing multiplication operation)    
00001 - mov (copying content from one register to other)   

ARITHEMATIC OPERATIONS    
00010 - add   
00011 - sub   
00100 - mul   
00101 - div   

LOGICAL OPERATIONS   
00110 - or   
00111 - and   
01000 - xor   
01001 - xnor    
01010 - nand   
01011 - nor   
01100 - not    

LOAD & STORE INSTRUCTIONS   
01101 - storereg (store content of register in data memory)   
01110 - storedin (store content of din bus in data memory)  
01111 - sendreg (send data from data memory to register)   

JUMP & BRANCH INSTRUCTIONS    
10000 - jump (jump to address (direct jump))    
10001 - jcarry (jump if carry is set)   
10010 - jnocarry (jump if carry bit is low)     
10011 - jsign (jump if sign bit is set)   
10100 - jnosign(jump if sign bit is low)   
10101 - jzero (jump if zero bit is set)   
10110 - jnozero(jump if zero bit is reset)   
10111 - joverflow(jump if overflow is set)   
11000 - jnooverflow(jump if overflow bit is low)   
  
11001 - halt (stop instruction)    

MEMORY STRUCTURE   
Memory design based on HARVARD ARCHITECTURE.Harvard Architecture is the digital computer architecture whose design is based on the concept of having separate memories for instructions & data.  

INSTRUCTION MEMORY 
* 32x32 address space   
* Each memory location contains one 32-bit word.    

DATA MEMORY       
* 16x16 address space   
* Each memory location consists of one 16-bit word.   

ADDRESSING MODES   

Basically, this microprocessor supports TWO addressing modes.     
* Register   
* Immediate      

FLOW    
The design is completed using FINITE STATE MACHINE approach.SIX STATES are used to monitor the action of CPU.   
* idle state      - To check the reset condition   
* fetch_inst      - Fetching instruction from program memory   
* dec_exe_inst    - Decoding & execution state of an instruction   
* next_inst       - To fetch next instruction   
* sense_halt      - To sense the stop bit    
* delay_next_inst - To maintain the delay of 4 clock ticks between two instructions.



