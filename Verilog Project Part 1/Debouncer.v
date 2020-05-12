`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:     EE3 lab1
// Module Name:     Debouncer
// Project Name:    Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     receives an unstable (toggling) digital signal as an input
//                  outputs a single cycle high (1) pulse upon receiving 2**(COUNTER_BITS-1) more ones than zeros.
//                  This creates a hysteresis phenomenon, robust to toggling.
//
//                  This module should be used to process a normally-off signal and to catch its long lasting "1" period and
//                  shrinking them into a single cycle "1".
//
// Dependencies:    None
//
// Revision:        4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Debouncer(clk, input_unstable, output_stable);

   input clk, input_unstable;
   output reg output_stable;
   parameter COUNTER_BITS = 7;
   reg [COUNTER_BITS+17:0] counter; // Hysteresis counter

   always @(posedge clk)
     begin
        if (input_unstable == 1)
            counter <= counter + 1;
        else
            counter <= (counter > {COUNTER_BITS{1'b0}}) ? counter  - 1 : counter;
        // Synchronously generate 1-cycle-pulse upon the transition from 0 mode to 1 mode.
        output_stable <= (counter == (1<<(COUNTER_BITS-1))) & input_unstable;
     end

endmodule
