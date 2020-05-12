`timescale 1ns/1ns
`define L 10
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     05/05/2019 00:16 AM
// Design Name:     
// Module Name:     Lim_Inc_tb
// Project Name:   Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     incrementor-decrementor test bench. - No changes required
//
// Dependencies:    Inc_Dec
//
// Revision:        4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Inc_Dec_tb();

    reg [3:0] a; 
    reg ci, cid, correct, loop_was_skipped;
    wire [3:0] sum;
    wire overflow, underflow;
    
    integer a_int,ci_int, cid_int,z;
    
    // Instantiate the UUT (Unit Under Test)
    Inc_Dec #(`L) uut (a, ci, cid, sum, overflow, underflow);
    
    initial begin
        correct = 1;
        loop_was_skipped = 1;

        #1
        for( a_int=0; a_int<16; a_int=a_int+1 ) begin
           for( ci_int=0; ci_int<=1; ci_int=ci_int+1 ) begin
                for( cid_int=0; cid_int<=1; cid_int=cid_int+1 ) begin
                    a = a_int[3:0]; ci = ci_int[0]; cid = cid_int[0];
                    #5 
                    z = a_int-cid_int+ci_int;
                    if (z >= `L)
                        correct = correct & (sum == 0) & overflow & ~underflow;
                    else if (z < 0)
                        correct = correct & (`L - 1 == sum) & ~overflow & underflow;
                    else
                        correct = correct & (z % `L == sum) & ~overflow & ~underflow;
                    loop_was_skipped = 0;
                end
           end
        end
        
        if (correct && ~loop_was_skipped)
            $display("Test Passed - %m");
        else
            $display("Test Failed - %m");
        $finish;
    end
endmodule

