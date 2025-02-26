//my id 1210007	
//Rana Musa
module alu (opcode, a, b, result );
input [5:0] opcode;
input [31:0] a, b;
output reg [31:0] result;  

parameter min =	6'b000001 , add = 6'b000100, andd= 6'b000101, absolute =6'b001000;
parameter orr=6'b001001,   max =6'b001010,	xorr=6'b000111,	 negative =6'b001011;
parameter avg =6'b001101, sub=6'b001110,   nott=6'b000110;

   //reg result [31:0] ;
	always @ (*) begin	
		
		if(opcode== 6'b000001) begin	        //opcode 1
      	 result <= a < b ? a : b;
				end	  
		
		else if(opcode== 6'b000100) begin	   //opcode 4
			result <= a + b;
		       end	
			  
		else if(opcode==6'b000101) begin	   //opcode 5
			result <= a & b;
				end	  
		
		else if(opcode==6'b000111) begin	   //opcode 7
			result <= a ^ b;
		end	 
		
		else if(opcode==6'b001000) begin	   //opcode 8
			result <= a < 0 ? -a : a;
				end
				
				
		else if(opcode==6'b001001) begin	   //opcode 9
			result <= a | b;
		end	  
		
		else if(opcode==6'b001010) begin	   //opcode 10
			result <= a > b ? a : b;
		end	 
		
		else if(opcode==6'b001011) begin	   //opcode 11
			result <= -a ;
		end	  
		
		else if(opcode==6'b001101) begin	   //opcode 13
			result <= (a + b) >> 1;
				end
				
				
		else if(opcode==6'b001110) begin	   //opcode 14
			result <= a - b;
		end		
		
		else if(opcode==6'b000110) begin	   //opcode 6
			result <= ~ a ;
				end
		
		
		
	end
	
endmodule  

 module ALU_tb;

  parameter WAIT_CYCLES = 5;

  reg [31:0] a, b;
  reg [5:0] opcode;
  
  wire [31:0] result;

  alu my_ALU (opcode, a, b, result);

  reg clk = 0;
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    a = 8'hFF; 
    b = 8'h0F;
    opcode = 6'b000100; // Addition

    $monitor("Time=%0t a=%h b=%h opcode=%h result=%h", $time, a, b, opcode, result);
    
    #WAIT_CYCLES a = 32'hABCDEFFF; b = 32'h12345678; opcode = 6'b001010; // Max
    #WAIT_CYCLES a = 32'h80000000; b = 32'h00000001; opcode = 6'b001000; // Absolute value
    #WAIT_CYCLES a = 32'hA5A5A5A5; b = 32'h5A5A5A5A; opcode = 6'b000101; // AND   
    #WAIT_CYCLES a = 32'h11223344; b = 32'h44332211; opcode = 6'b001011; //	-a
	
    #WAIT_CYCLES $finish; 
  end

endmodule	

module reg_file (clk, valid_opcode, addr1, addr2, addr3, in , out1, out2);
input clk;
input valid_opcode;
input [4:0] addr1, addr2, addr3;
input [31:0] in;
output reg [31:0] out1, out2; 	 
reg [31:0] memory[31:0];

initial begin
  memory[0] = 32'h0000;	 
  memory[1] = 32'h1F06;
  memory[2] = 32'h33A8;
  memory[3] = 32'h3C66;	
  memory[4]=  32'h1F5A;	
  memory[5]=  32'hE6C;	
  memory[6]=  32'h269A;	
  memory[7]=  32'h2038;	
  memory[8]=  32'hD68;	
  memory[9]=  32'hB2;	
  memory[10]=  32'h94A;	
  memory[11]=  32'h206E;	
  memory[12]=  32'h250;	
  memory[13]=  32'h1D06;	
  memory[14]=  32'h294C;	
  memory[15]=  32'h1DFC;	
  memory[16]=  32'h4D6;	
  memory[17]=  32'h3E88;	
  memory[18]=  32'h97A;	
  memory[19]=  32'h2E9A;	
  memory[20]=  32'h1A44;	
  memory[21]=  32'h31F6;	
  memory[22]=  32'h12EA;	
  memory[23]=  32'h1BC4;	
  memory[24]=  32'h1898;
  memory[25]=  32'hCFA;	
  memory[26]=  32'h2A60;	
  memory[27]=  32'h396A;	
  memory[28]=  32'h3FFA;	
  memory[29]=  32'h3C60;	
  memory[30]=  32'h4EC;	
  memory[31]=  32'h0000;	
end

always @ (posedge clk) begin 
	
	out1 <=	 memory[addr1];	 
	out2 <=	 memory[addr2];	
	memory [addr3] <= in;
	end

endmodule
`timescale 1ns/1ps

module reg_file_tb;

  // Inputs
  reg clk;
  reg valid_opcode;
  reg [4:0] addr1, addr2, addr3;
  reg [31:0] in;

  // Outputs
  wire [31:0] out1, out2;

  reg_file uut (
    .clk(clk),
    .valid_opcode(valid_opcode),
    .addr1(addr1),
    .addr2(addr2),
    .addr3(addr3),
    .in(in),
    .out1(out1),
    .out2(out2)
  );

initial begin
  clk = 0;
  // Run for 50 clock cycles
  repeat (50) #5 clk = ~clk;
  $finish; 
end

 
  // Test stimulus
  initial begin
    // Initialize inputs
   valid_opcode = 1;
    addr1 = 5;
    addr2 = 10;
    addr3 = 15;
    in = 32'h12345678;

    #10; 
    $display("Time=%0t: clk=%b, valid_opcode=%b, addr1=%0d, addr2=%0d, addr3=%0d, in=%h, out1=%h, out2=%h",
             $time, clk, valid_opcode, addr1, addr2, addr3, in, out1, out2);


    in = 32'hef01;
    addr1 = 7;
    addr2 = 20;
    addr3 = 25;
    #10; 
    $display("Time=%0t: clk=%b, valid_opcode=%b, addr1=%0d, addr2=%0d, addr3=%0d, in=%h, out1=%h, out2=%h",
             $time, clk, valid_opcode, addr1, addr2, addr3, in, out1, out2);

    in = 32'habcdef01;
    addr1 = 15;
    addr2 = 28;
    addr3 = 10;
    #10; 
    $display("Time=%0t: clk=%b, valid_opcode=%b, addr1=%0d, addr2=%0d, addr3=%0d, in=%h, out1=%h, out2=%h",
             $time, clk, valid_opcode, addr1, addr2, addr3, in, out1, out2);
    // End simulation
    $stop;
  end

endmodule

module mp_top (clk, instruction , result );
input clk;
input [31:0] instruction;
output reg [31:0] result;

  reg [5:0] opcode;
  reg [4:0] src_reg1, src_reg2, dest_reg;
  reg [31:0] data_input;
  wire [31:0] num1, num2;
  

 always @(posedge clk) begin
    opcode =instruction[5:0];
    src_reg1 = instruction[10:6];
    src_reg2 =instruction[15:11];
    dest_reg =instruction[20:16];	
		
 end 


 reg_file ut (
    .clk(clk),
    .valid_opcode(opcode),
    .addr1(src_reg1),
    .addr2(src_reg2),
    .addr3(dest_reg),
    .in(result),
    .out1(num1),
    .out2(num2)
  );  
  alu my_ALU (
  .opcode(opcode), 
  .a(num1), 
  .b(num2),
  .result(result));
endmodule


`timescale 1ns/1ns

module tb_mp_top;

  // Inputs
  reg clk;
  reg [31:0] instruction;

  // Outputs
  wire [31:0] result;

 
  
  
  reg valid_opcode;
  reg [4:0] addr1, addr2, addr3;
  reg [31:0] in;

  // Outputs
  wire [31:0] out1, out2;
  
   reg_file ut (
    .clk(clk),
    .valid_opcode(valid_opcode),
    .addr1(addr1),
    .addr2(addr2),
    .addr3(addr3),
    .in(result),
    .out1(out1),
    .out2(out2)
  );   
  
   reg [31:0] instructions [31:0];	
  
  	 
	  
	  
//array of instructions	  
   initial begin	 
  instructions[0] =  32'h13351141; 
  instructions[1] =  32'h18915584; 
  instructions[2] = 32'h88010205; 
  instructions[3] = 32'hFF6087C7; 
  instructions[4] = 32'h2aa1a688;   
  instructions[5] =  32'h2bbbbb09;
  instructions[6] = 32'h1898440A; 
  instructions[7] = 32'hffffc00B; 
  instructions[8] = 32'h9FC7C90D; 
  instructions[9] = 32'h9FF7270E; 
  instructions[10] = 32'h9AF63B06;
  instructions[11] =  32'h18915500;

end
  
  
  reg [31:0] a, b;
  reg [5:0] opcode;
  

  alu my_ALU (opcode, out1, out2, result);

  initial begin
    clk = 0;
  end 
	 always #5 clk = ~clk;


  initial begin
    



    // Test with multiple instructions
    instruction = instructions[0]; // Example min 
	valid_opcode = 1;	 
    addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
	
	
	$display("________________________________________________________________________________________________________________");	 
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
	
    #50;
	if(result == 32'he6c)	 
	
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
		
		
  
	 
	 
	 
	 
	 
	 
    instruction = instructions[1]; // Example add 
	valid_opcode = 1;	 
	
 addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	   
		
 $display("________________________________________________________________________________________________________________");	
 if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
    #50; 
	if(result == 32'h1c34)	

	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
   	
	 
	 
	 
	 
		
		
   instruction =instructions[2]; // Example and
 
	//
     addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	 
	#50;	
	$display("________________________________________________________________________________________________________________"); 
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'h0)	   
		   
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);   
	 
	
	 
	 
	 
	 
	 
	 
	 
	 
	 instruction = instructions[3]; // Example xor	 
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
     
	#50;  
	$display("________________________________________________________________________________________________________________"); 
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'h4d6)	
 	 
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
	 
	 
	 
	  instruction = instructions[4] ;// Example ABSOLUTE VALUE	 
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
     
	#50; 
	$display("________________________________________________________________________________________________________________");	
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'h2A60)										 
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
	 
	 
	 
	 
	 
	instruction =instructions[5];  //OR
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
	
	
	#50;	
	$display("________________________________________________________________________________________________________________");
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'h1BD4)	   																																								  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
	 
	 
	 
	 
	   instruction = instructions[6]; // Example MAX	 
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
     
	#50;  
	$display("________________________________________________________________________________________________________________");
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'hD68)	  																																								 
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
	 
	 
	 
	 
	    instruction =instructions[7]; // Example NEGATIVE	 
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
     
	#50; 
	 $display("________________________________________________________________________________________________________________");
   	if(result == 32'hFFFFFB2A)	 																																							 
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
	 
	 
	 
	 
	 
	   instruction = instructions[8]; // Example AVG	 
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
     
	#50; 
	$display("________________________________________________________________________________________________________________");	
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'h162A)																																									   
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
	 
	 
	 
	  
	   instruction =instructions[9]; // Example SUB	 
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
     
	#50;
	$display("________________________________________________________________________________________________________________"); 
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'h20A0)																																									 
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
	 
	 
	 
	 
	    instruction = instructions[10]; // Example NOT	 
	   addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	
     
	#50; 
	$display("________________________________________________________________________________________________________________");	
	if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
   	if(result == 32'hFFFFFDAF)																																								  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);	 
	 
	 
	 
	 
	 
	 
	 
	  instruction = instructions[11]; // Example invalid opcode
	valid_opcode = 1;	 
	
 addr1 = instruction[10:6];
    addr2 = instruction[15:11];
    addr3 = instruction[20:16];
	opcode  = instruction[5:0];	   
		
 $display("________________________________________________________________________________________________________________");	
 if(opcode == 6'b0 | opcode == 6'b000010 | opcode== 6'b000011 | opcode== 6'b001111 | opcode== 6'b001100)  
	
		 $display ("!!!!!!!!!!!!!!!!!!!!invalid opcode!!!!!!!!!!!!!!!!!!!");
    #50; 
	if(result == 32'h1c34)	

	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|PASS"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	else  
	 $display("INSTRUCTION : %h |	OPCODE: %d  | ADDRESS1 : %d | ADDRESS2 : %d | VALUE1: %h | VALUE2: %h |	RESULT: %h	|FAIL"
	 , instruction,opcode,addr1,addr2,out1, out2 ,result);
	 
	 
	 
   
    #1000;
    $finish;
  end	

endmodule

	 