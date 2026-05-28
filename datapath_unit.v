module datapath_unit (clk, reset, base_ld, exec_en, baseA_in, baseB_in, baseC_in, rdataA, rdataB, addrA, addrB, addrC, wdataC, we, exec_done);

	 input clk, reset, base_ld, exec_en;
	 //clk is the clock
	 //reset is the rest signal, such that when reset = 1 the CU goes back to the inital state
	 //base_ld is the control signal recived from the CU such that when base_ld is 1, we load the base addreses
	 //exec_en is a control signal from the CU control vector such that when exec_en is 1,we start executing the multipication
	 
    input [5:0] baseA_in, baseB_in, baseC_in;
    //baseA_in, baseB_in and baseC_in hold the base addreses of A,B,C and is obtained from the instruction unit 
	 
	 input wire [15:0] rdataA, rdataB; //rdataA and rdataB are the data values read back from memory

	 output reg [5:0] addrA, addrB, addrC; //addrA, addrB and addrC are the addresses sent to memory for reading A, reading B and writing C
    output reg [15:0] wdataC; //wdataC is the data we want to write into C
    output reg we; //we is the write enable signal sent to memory
		
	 output reg exec_done;
	 //the output of the data path unit is 1 when the multipication is done and it is sent to the control unit

    reg [5:0] BASE_A, BASE_B, BASE_C; //the base address but as registers 
    reg [1:0] i, j, k; //i,j,k are the loop counters, each goes from 0 to 3
    reg [31:0] sum; //the sum is 32 bits as multplying two 16bit numbers can give up to 32bits of data

	 reg [2:0] state,next_state; //internal current state of the datapath so we can sequence the read, multiply and write operations and a next_state

	 parameter PREP  = 3'b000; //we are in this state until we resive the control signal exec_en from the CU
	 parameter LOAD  = 3'b001; //we remain in this state until we recive the base_ld signal from the CU
	 parameter SET   = 3'b010; //in this state we set the addresses of A and B by getting the base from the instruction set
	 parameter ACC   = 3'b011; //in this we use the values from rdataA and rdataB and update the sum for c[i][j]
	 parameter WRITE = 3'b100; //thisis the state where we write the final sum into C[i][j]
	 parameter DONE  = 3'b101; //since we have used moore implmentation we need a seprate state to signal done=1

	 
	 
	 
	 always @(posedge clk or posedge reset) //change state only at the rising edge of the clock or since reset is asynch, at the falling edge of reset
	 begin
        if (reset)//reset is active high hence if(reset)
            state <= PREP;//go back to inital state (the prep state)
        else
            state <= next_state;//at the rising edge of the clock go to the next state
    end

	 
	 
	 
	 
    // next-state logic
    always @(*) //computing the next state is combinational logic, hence we can compute it throughout the clock cycle. however the current state is only updated at the rising edge as seen in the block above
	 //since we have multiple inputs instead of saing always @(state or all the inputs), we will just use *
	 begin
        //next_state = state;
        case (state)//check the current state
            PREP: //when in state prep
                if (base_ld ) //if the base_ld signal is high
                    next_state = LOAD; //go to state LOAD, where we load the base addresses
                else//if execution signal is not enabled than we wait at PREP
                    next_state = PREP;//remain in state PREP				  
						  
				LOAD://when in the LOAD state
					if(exec_en)//if we get the signal to start executing from the CU
						next_state=SET;//then we go to SET
					else
						next_state=LOAD;//remain in load
            
            SET: //when in state SET
                next_state = ACC; //after you SET the addresses, we use go to ACC to start calculating c[i][j]

            ACC: //when at the ACC state
                if (k == 2'b11)///once k=3 then C[i][j] has been computed, so we go to WRITE state
                    next_state = WRITE;//go to state write
                else//if k!=3 than there are more values to itterate over from row i of matrix A and col j of matrix B so in order to fetch the new values of rdataA and rdataB we go back to state SET
                    next_state = SET;//go to state set to set the addr for the new A and B values

            WRITE: //when you are in the WRITE state
                if(j==2'b11 && i==2'b11)//if we finished going over all rows of A and all cols of B than we are done 
								next_state = DONE;//C matrix is ready so we go to matrix DONE
					 else//If we still havent finished the matrix multipication than go back to set new addresses for the new elements
								next_state = SET;
		
				DONE:
					next_state=PREP;//go back to prep once you finish the operation
		
            default: 
                next_state = PREP;//the default state is PREP 
        endcase
    end
	 
	 
	 
	
	 
    always @(posedge clk or posedge reset) 
	 begin
		   we <= 1'b0; //write signal low unless we are in the write state

		  case (state)//check the current state 
            
				PREP: begin		
					exec_done <= 1'b0; //clear done signal
					sum       <= 32'h0; //clear sum
					i <= 2'b0; j <= 2'b0; k<= 2'b0; //clear counters
				end
				
				LOAD: begin//Load all the base address from the instruction unit if the base load signal is 1 
					BASE_A <= baseA_in;
					BASE_B <= baseB_in;
					BASE_C <= baseC_in;
				
				end
				
            SET: begin
						addrA <= BASE_A + (i*4 + k); //set the addres of A
						addrB <= BASE_B + (k*4 + j); //set the address of B
					end
					 
					 
            ACC: begin
						sum <= sum + (rdataA * rdataB); // sum=sum+ A[i][k]*B[k][j]
						//we need to go over every elment in A of row i and every element in B of col j
						if (k != 2'b11)//since c[i][j] consists of the sum of 4 products than we will increment k to do the next product
							k     <= k + 2'b01; //move to the next element in the row i for A and col j for B
				end
					
					

					
					WRITE: begin
						addrC  <= BASE_C + (i*4 + j); //set the address c[i][j]
						we     <= 1'b1; //enable the write signal
						wdataC <= sum[15:0]; //c[i][j]=sum
						sum    <= 32'h0; //clear sum for the next C element
						k      <= 2'b0; //reset k since for every new C[i][j] k must start again from 0

						if (j == 2'b11) begin //if we finished all the cols in the current row
							j <= 2'b0;     //go back to first col, so we start from the first col of B for the next row of A
							
							if(i!=2'b11) begin//we didnt finish all rows of A so move to the next row of A
								i     <= i + 2'b01; //move to the next row
							end
							
						end
						
						else begin//if we arent done with all the cols for row i, then move to the next col
							j     <= j + 2'b01; //move to the next col
						end
	
					end
										
					
					DONE: begin
						exec_done <= 1'b1; //raise done flag which is a status signal sent to the control unit
					end
					
	endcase
	end
	 
endmodule
