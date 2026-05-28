module matrix_mult_top (
    input         clk, // 50 MHz
    input         reset, // active high reset
    input         start, // active high input
    input  [23:0] IR_in, // fixed matrix-multiply instruction
    output        done // assert when operation is complete
);

    // Instruction unit connection wires
    wire [5:0] baseA_in, baseB_in, baseC_in;
	 wire opp_code_flag;

	// Control unit connection wires
    wire base_ld, exec_en,exec_done;
	
	// Datapath and memory wires
    wire  we;
	 wire [5:0]  addrA, addrB,addrC;
    wire [15:0] wdataC, rdataA, rdataB;
	
	// Calling the instruction unit and passing the needed varabiles
    instruction_unit IU (clk,reset,start,IR_in, opp_code_flag, baseA_in,baseB_in,baseC_in);
	 
	// Calling the control unit and passing the needed varabiles
    control_unit CU (clk,reset,start, exec_done, opp_code_flag,base_ld,exec_en,done);

	// Calling the datapath unit and passing the needed varabiles
    datapath_unit DU (clk,reset, base_ld, exec_en, baseA_in, baseB_in, baseC_in,rdataA, rdataB, addrA, addrB, addrC, wdataC, we, exec_done);
 
    // Calling the memory unit and passing the needed varabiles
    pseudo_memory MEM (clk, addrA,addrB,addrC,we,wdataC,rdataA,rdataB);

endmodule