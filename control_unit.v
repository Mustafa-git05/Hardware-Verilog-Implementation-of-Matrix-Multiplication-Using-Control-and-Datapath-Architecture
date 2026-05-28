module control_unit (clk, reset, start, exec_done, opp_code_flag, base_ld, exec_en,done);
//Control Unit Module 

    input clk,reset,start,exec_done,opp_code_flag;
	 //clk is the clock
	 //reset is the rest signal, such that when reset = 1 the CU goes back to the inital state
	 //start is the signal that starts the operation
	//exec_done is a signal that comes from the datapath once the datapath has completed the matrix multipication
	//opp_code_flag is a flag that will be set if the opp code is 0001 (the multipication opp code)
	
	output reg base_ld, exec_en,done;
	//base_ld is part of the control vector, it signals the datapath to load the base addresses
	//exec_en is also part of the control vector, tells the datapath to start its execution and multiply the matrix
	//done si 1 and tells us when the whole operation is completed
		
    reg [1:0] state, next_state; //state is the present state and nex_state is the next state

    parameter  T0_IDLE = 2'b00; //this is the state you are in before the start signal is 1, when the system is idle
    parameter  T1_LOAD = 2'b01; //this is the state where you send the base_ld signal to the datapath which tells it to load the bases
    parameter  T2_EXEC = 2'b10; //in this state we send the exec_en signal telling our datapath to start executing the multipication
    parameter  T3_DONE = 2'b11; //since we have used moore implmentation we need a seprate state to signal done=1

	 
    always @(posedge clk or posedge reset) //change state only at the rising edge of the clock or since reset is asynch, at the falling edge of reset
	 begin
        if (reset)//reset is active high hence if(reset)
            state <= T0_IDLE;//go back to inital state
        else
            state <= next_state;//at the rising edge of the clock go to the next state
    end

	 
    // next-state logic
    always @(*) //computing the next state is combinational logic, hence we can compute it throughout the clock cycle. 
	 //however the current state is only updated at the rising edge as seen in the block above
	 //since we have multiple inputs instead of saing always @(state or all the inputs), we will just use *
	 begin
        //next_state = state;
        case (state)//check the current state
            T0_IDLE: //when in state idle
                if (start && opp_code_flag) //if the start signal is one and the oppcode flag is 1 (flag is 1 when oppcode == 4'b0001)
                    next_state = T1_LOAD; //go to state load, where you notify the DP to load the bases
                else//if start signal is 0 or oppcode flag is not 1
                    next_state = T0_IDLE;//remain in state idle
            
            T1_LOAD: //when in state load
                next_state = T2_EXEC; //after you send the load signal, always send the execute multipication signal

            T2_EXEC: //when at the execute state
                if (exec_done)//if the data path signal exec_done is 1
                    next_state = T3_DONE;//go to state done
                else//if the exec_done signal is 0
                    next_state = T2_EXEC;//remain in state exec, until the multpication is done

            T3_DONE: //when you are in state done
                next_state = T0_IDLE;//set done signal to 1, notfying that the operation is complete and than return to idle

            default: 
                next_state = T0_IDLE;//the default state is idle 
        endcase
    end
	 
	 
	 
    always @(state) //in a moore machine the output depends only on the current state
	 begin
        base_ld = 1'b0;//initalize control vector element base_ld to 0
        exec_en = 1'b0; //initalize control vector element exec_en to 0
        done    = 1'b0;//initilize CU output signal to 0
        
		  case (state)//check the current state 
            
				T0_IDLE: begin base_ld = 1'b0;exec_en = 1'b0;done = 1'b0; end//in the idle state, no signals are set
				
            T1_LOAD: 
                base_ld = 1'b1;//signal to the data path to start loading the base addreses
            T2_EXEC: 
                exec_en = 1'b1; // signal to the data path to start multipication process
            T3_DONE: 
                done = 1'b1; //signal that the entire process is complete
        endcase
	end
	
endmodule