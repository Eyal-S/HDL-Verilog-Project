`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:     
// Module Name:     Ctl_tb
// Project Name:   Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     test bennch for the control.
// Dependencies:    None
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Ctl_tb();

    reg clk, reset, trig, set, complete, up, down; 
    reg correct;
    wire init_regs, count_enabled, min, inc, dec;
    wire [3:0] state;

    Ctl uut (clk, reset, trig, set, up, down, complete, init_regs, count_enabled, inc, dec, min, state);
    
    initial begin
        correct = 1;
        clk = 0;
        reset = 1;
        trig = 0;
        set = 0;
        complete = 0;
        up = 0;
        down = 0;
        #10
        reset = 0;
        correct = correct & init_regs & ~count_enabled & ~min & ~inc & ~dec;
        #1
        
        set = 1;
        #10
        set = 0;
        correct = correct & ~init_regs & ~count_enabled & min & (inc == up) & (dec == down);

        up = 1;
        #10
        correct = correct & ~init_regs & ~count_enabled & min & (inc == up) & (dec == down);
        
        up = 0;
        down = 1;
        #10
        correct = correct & ~init_regs & ~count_enabled & min & (inc == up) & (dec == down);

        set = 1;
        #10
        set = 0;
        correct = correct & ~init_regs & ~count_enabled & ~min & (inc == up) & (dec == down);

        up = 1;
        down = 0;
        #10
        correct = correct & ~init_regs & ~count_enabled & ~min & (inc == up) & (dec == down);

        set = 1;
        #10
        set = 0;
        correct = correct & ~init_regs & ~count_enabled & min & (inc == up) & (dec == down);

        trig = 1;
        #10
        trig = 0;
        #1
        correct = correct & ~init_regs & count_enabled & ~min & ~inc & ~dec;
        #9
        correct = correct & ~init_regs & count_enabled & ~min & ~inc & ~dec;
        #10
        correct = correct & ~init_regs & count_enabled & ~min & ~inc & ~dec;
        
        trig = 1;
        #10
        trig = 0;
        correct = correct & ~init_regs & ~count_enabled & min & (inc == up) & (dec == down);
 
        trig = 1;
        #10
        trig = 0;
        #1
        correct = correct & ~init_regs & count_enabled & ~min & ~inc & ~dec;
        #9
        correct = correct & ~init_regs & count_enabled & ~min & ~inc & ~dec;
        
        complete = 1;
        #10
        correct = correct & init_regs & ~count_enabled & ~min & ~inc & ~dec;

        #10

        if (correct)
            $display("Test Passed - %m");
        else
            $display("Test Failed - %m");
        $finish;
    end

    always #5 clk = ~clk;

endmodule
