`timescale 1ns/10ps
`define WIDTH 4
//////////////////////////////////////////////////////////////////////////////////
// Company:         
// Engineer:           Eyal S
//
// Create Date:     04/05/2019 08:59:38 PM
// Design Name:     
// Module Name:     Adder_tb
// Project Name:    Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Variable length binary adder. The parameter N determines
//                  the bit width of the operands.
//
// Dependencies:    Adder(2)
//
// Revision         4.0 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Adder_tb();

    reg [`WIDTH-1:0] a;
    reg [`WIDTH-1:0] b;
    reg ci, correct, loop_was_skipped;
    wire [`WIDTH-1:0] sum;
    wire co;

    integer ai,bi,cii;

    // Instantiate the UUT (Unit Under Test)
    Adder #(`WIDTH) uut (a, b, ci, sum, co);

    initial begin
        correct = 1;
        loop_was_skipped = 1;
        #1

        for( ai=0; ai<2**`WIDTH; ai=ai+1 ) begin
            for( bi=0; bi<2**`WIDTH; bi=bi+1 ) begin
                for( cii=0; cii<=1; cii=cii+1 ) begin
                    a = ai; b = bi; ci = cii;
                    #5
                    correct = correct & (a + b + ci == {co,sum});
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
