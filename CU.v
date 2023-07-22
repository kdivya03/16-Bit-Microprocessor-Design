//CONTROL UNIT design using FINITE STATE MACHINE
 
//Fields of INSTRUCTION REGISTER
`define opcode    IR[31:27]   // OPCODE SIZE - 5bit
`define rdst      IR[26:22]  // Destination Register - 5bit
`define rsrc1     IR[21:17]  // Address of first operand...size - 5bit
`define imm_mode  IR[16]     // Determines the addressing mode...MODE - 0 = Register addresssing mode...MODE - 1 = Immediate addressing mode..size = 1bit
`define rsrc2     IR[15:11]  //Address of second operand...size = 5bit
`define isrc      IR[15:0]   // Specifies the operand value in immediate addressing mode when mode = 1...size = 16bit
 
`timescale 1ns / 1ps
module CU(input clk,sys_rst);
reg [31:0] IR;    
reg jmp_flag = 0;
reg stop = 0;
reg [31:0] inst_mem [31:0];

//FSM STATES
parameter    idle = 0;                  //idle : check reset state
parameter    fetch_inst = 1;            // fetch_inst : load instrcution from Program memory
parameter    dec_exec_inst = 2;         // dec_exec_inst : execute instruction + update condition flag
parameter    next_inst = 3;             // next_inst : next instruction to be fetched
parameter    sense_halt = 4;            //checking the halt condition
parameter    delay_next_inst = 5;       //state used to delay the next instruction

reg [2:0] state = idle, next_state = idle;
reg [2:0] count = 0;
integer PC = 0;

//reset decoder
always@(posedge clk)
begin
 if(sys_rst)
   state <= idle;
 else
   state <= next_state; 
end
 
//next state decoder + output decoder
 
always@(*)
begin
  case(state)
   idle: begin
     IR         = 32'h0;
     PC         = 0;
     next_state = fetch_inst;
   end
 
  fetch_inst: begin
    IR          =  inst_mem[PC];   
    next_state  = dec_exec_inst;
  end
  
  dec_exec_inst: begin
    decode_inst();
    decode_condflag();
    next_state  = delay_next_inst;   
  end
  
  
  delay_next_inst:begin
  if(count < 4)
       next_state  = delay_next_inst;       
     else
       next_state  = next_inst;
  end
  
  next_inst: begin
      next_state = sense_halt;
      if(jmp_flag == 1'b1)
        PC = `isrc;
      else
        PC = PC + 1;
  end
  
  
 sense_halt: begin
    if(stop == 1'b0)
      next_state = fetch_inst;
    else if(sys_rst == 1'b1)
      next_state = idle;
    else
      next_state = sense_halt;
 end
  
  default : next_state = idle;
  
endcase  
end

// count update 
 
always@(posedge clk)
begin
case(state)
 
 idle : begin
    count <= 0;
 end
 
 fetch_inst: begin
   count <= 0;
 end
 
 dec_exec_inst : begin
   count <= 0;    
 end  
 
 delay_next_inst: begin
   count  <= count + 1;
 end
 
  next_inst : begin
    count <= 0;
 end
 
  sense_halt : begin
    count <= 0;
 end
 
 default : count <= 0;
 
  
endcase
end
endmodule

