`timescale 10ns/1ns

module matrix_mult_top_tb;
    reg clk;
    reg reset;
    reg start;
    reg [23:0] IR_in;
    wire done;

    // Instantiate the top module
    matrix_mult_top TB( clk, reset, start, IR_in, done );

    // Clock generation
    // timescale is 10ns so #1 = 10ns
    // For 50 MHz: 1/50Mhz = period = 20ns. half of 20ns is 10ns so clock pulse must change every 10ns, so #1
	 always begin
        #1 clk = ~clk;
    end

    initial begin
        clk   = 1'b0;//clock pulse starts from low
        reset = 1'b1; //initally we reset the system
        start = 1'b0; //dont start the system
        IR_in = 24'b0;//no instruction code initally

        #2;            
        reset = 1'b0;//after 1 clcok cycle we put reset to low
        IR_in = 24'b000100000001000010000000; //and we load the instruction set
        //Instruction set bit representation:
		  //[23:20]=0001 is the opcode (matrix mult)
        //[19:14]=000000 is the BASE_A = 0
        //[13:8] =010000 is the BASE_B = 16
        //[7:2] =100000 is the BASE_C = 32

        #2;
        start = 1'b1;//after 1 clock cycle start the multipication process

        #380;//gives enough time to complete the whole matrix multpication
		  //we have 16 C(i)(j), and each c(i)(j) has 4 multipications and each multipication is a set + accumlate state so 2 clock cycle 
		  //2*4=8 and than a write cycle so 9 cycle per c(i)(j)
        $stop;
    end

	 

    integer i, j;

    initial begin
        #320;//in order to display the matrixes at the end after computation

        $write("\nMATRIX A\n");
        for (i = 0; i < 4; i = i + 1) begin//i from 0 to 3 (traverses each row)
            for (j = 0; j < 4; j = j + 1)//j from 0 to 3 traverses each col of each row
                $write("%d ", TB.MEM.mem[0 + i*4 + j]);//print all elements of matrix A '0' is the Base
            $write("\n");//new line
        end
		  //TB.MEM.mem means: Go to the instantiated top module, then go to its MEM module (which is the name of the pseudo memory module), then go to mem (which is the register file contating the matrices)

		  //same concept as printing matrix A, just simply change the base address
        $write("\nMATRIX B\n");
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1)
                $write("%d ", TB.MEM.mem[16 + i*4 + j]);//print all elements of matrix B '16' is the Base
            $write("\n");
        end
		  
        $write("\nMATRIX C\n");
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1)
                $write("%d ", TB.MEM.mem[32 + i*4 + j]);//print all elements of matrix C '32' is the Base
            $write("\n");
        end
		  
    end

endmodule



