//this module will be responsible for accessing the memory, and reading and writting to it
module pseudo_memory (clk, addrA,addrB,addrC, we, wdataC, rdataA,rdataB);
	  
	input clk;//the clock signal
	input we; //write enable bit, such that if we=1, we can write at the pos clock edge
	input [5:0] addrA,addrB,addrC; //to refrence a address we need 6 bits, 2^6=64 which allows us to refrence any addr from 0 to 63
	input[15:0] wdataC; // the data that we will write to memory, its 16bit since every word is 16bit
	output [15:0] rdataA,rdataB; // the data that we will read from memory, its 16bit since every word is 16bit
			
	//this is the memory. its 64 words, where each word is 16 bits. The first addr is mem[0] and the last is mem[63]
	
	reg [15:0] mem [0:63];
	 
		 
	integer n; //for the for loop to clear all elements initally

	initial begin
		for (n = 0; n < 64; n = n + 1)
			mem[n] = 16'h0000; // clear all memory first
		
		
		
		// initilize memory with matrix A
		mem[0]  = 16'h0001;
		mem[1]  = 16'h0002;
		mem[2]  = 16'h0003;
		mem[3]  = 16'h0004;
		mem[4]  = 16'h0005;
		mem[5]  = 16'h0006;
		mem[6]  = 16'h0007;
		mem[7]  = 16'h0008;
		mem[8]  = 16'h0009;
		mem[9]  = 16'h000A;
		mem[10] = 16'h000B;
		mem[11] = 16'h000C;
		mem[12] = 16'h000D;
		mem[13] = 16'h000E;
		mem[14] = 16'h000F;
		mem[15] = 16'h0010;

		// initilize memory matrix B 
		mem[16] = 16'h0001;
		mem[17] = 16'h0000;
		mem[18] = 16'h0000;
		mem[19] = 16'h0000;
		mem[20] = 16'h0000;
		mem[21] = 16'h0001;
		mem[22] = 16'h0000;
		mem[23] = 16'h0000;
		mem[24] = 16'h0000;
		mem[25] = 16'h0000;
		mem[26] = 16'h0001;
		mem[27] = 16'h0000;
		mem[28] = 16'h0000;
		mem[29] = 16'h0000;
		mem[30] = 16'h0000;
		mem[31] = 16'h0001;
		// addresses 32-47 will be filled up by the results and represent matrix C and addresses 48-63 are unused/reserved 



		/*
		//Another Test Case:
		// Matrix A:
		mem[0]  = 16'h0002;
		mem[1]  = 16'h0001;
		mem[2]  = 16'h0003;
		mem[3]  = 16'h0004;
		mem[4]  = 16'h0000;
		mem[5]  = 16'h0001;
		mem[6]  = 16'h0002;
		mem[7]  = 16'h0001;
		mem[8]  = 16'h0001;
		mem[9]  = 16'h0000;
		mem[10] = 16'h0001;
		mem[11] = 16'h0000;
		mem[12] = 16'h0003;
		mem[13] = 16'h0002;
		mem[14] = 16'h0001;
		mem[15] = 16'h0001;

		//matrix B:
		mem[16] = 16'h0001;
		mem[17] = 16'h0002;
		mem[18] = 16'h0000;
		mem[19] = 16'h0001;
		mem[20] = 16'h0000;
		mem[21] = 16'h0001;
		mem[22] = 16'h0003;
		mem[23] = 16'h0002;
		mem[24] = 16'h0002;
		mem[25] = 16'h0000;
		mem[26] = 16'h0001;
		mem[27] = 16'h0000;
		mem[28] = 16'h0001;
		mem[29] = 16'h0001;
		mem[30] = 16'h0000;
		mem[31] = 16'h0002;
		*/
			
	end		
							
		 
		  
		

	 always @(posedge clk) //at the positive rising edge of the clock
	 begin
		  if (we) // if the write enable is 1
				mem[addrC] <= wdataC; //than we will write data to the address specified into the memory 
	 end
		
		
	 assign rdataA = mem[addrA];//this is how we read the data, simply access the memory at the given address addrA and store it in rdataA
	 assign rdataB = mem[addrB]; //this is how we read the data, simply access the memory at the given address addrB and store it in rdataB

	 
endmodule

