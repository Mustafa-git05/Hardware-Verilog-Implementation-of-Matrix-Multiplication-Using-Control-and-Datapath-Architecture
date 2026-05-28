module instruction_unit (clk,reset,start,IR_in,opp_code_flag, BASE_A, BASE_B, BASE_C);

	 input clk, reset,start;
	 //clk is the clock signal
	 //reset is the rest signal, such that when reset = 1 the CU goes back to the inital state
	 //start is the start signal, such that when start =1 the system operation starts
    input  [23:0] IR_in;//this is the instruction register
    output opp_code_flag;//this flag will be set if the opp code is 0001 (the multipication opp code)
	 output [5:0]  BASE_A, BASE_B,BASE_C; // these are the base addreses that we extract from the instruction register for A, B and C
	
    reg [23:0] IR; // i want to save the instruction in a register so that i can clear it when reset is on, else i wont be able to clear a input


    always @(posedge clk or posedge reset) begin//change only at the rising edge of the clock or since reset is asynch, at the falling edge of reset
   
        if (reset)//reset is active high hence if(reset)
            IR <= 24'd0;//clear the instruction register
        else if (start)//else if the start signal is on
            IR <= IR_in;//then we move the instruction input and save it into out instruction register 
    end

    // Decode the instruction fields as per the project document 
	 assign opp_code_flag = (IR[23:20] == 4'b0001); //this is a multipication opp code flag, if the oppcode==4'b0001, than we are multypling the matrix hence the flag=1
    assign BASE_A = IR[19:14];//base address of matrix A
    assign BASE_B = IR[13:8];//base address of matrix B
    assign BASE_C = IR[7:2];//base address of matrix C
	//note that IR[1:0] is reserved so I will do nothing to it

endmodule

