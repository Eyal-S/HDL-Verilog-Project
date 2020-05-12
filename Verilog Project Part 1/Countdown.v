`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         
// Engineer:          Eyal S
//
// Create Date:     13/12/2019 08:59:38 PM
// Design Name:     
// Module Name:     Countdown
// Project Name:    Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Top module of the Countdown circuit which counts down the
//                  minutes:seconds from a inital value.
//                  btnC button is used as a synchronous reset
//                  btnR button is used as a trigger to start and pause the counting.
//                  While the system is in the paused mode, the counting is paused and
//                  the btnU/btnD buttons are used to increase/decrease the counter
//                  initial value.
//                  btnL button is used to transit the system from the initial mode
//                  into a paused mode and to toggle between setting the minutes
//                  and setting the seconds.
//                  The Countdown's time reading is output using an, seg and dp signals
//                  that should be connected to the 4-digit-7-segment display and driven
//                  by 100MHz clock.
//                  The led outputs must be organized as follows:
//                  led[0]=1 <--> counter is idle
//                  led[1]=1 <--> counter is counting
//                  led[3:2]=11 <--> counter is paused and seconds-setting is allowed
//                  led[5:4]=11 <--> counter is paused and minutes-setting is allowed
// Dependencies:    Debouncer, Ctl, Counter, Seg_7_Display
//
// Revision         4.0 - File Created
//
//////////////////////////////////////////////////////////////////////////////////
module Countdown(clk, btnC, btnU, btnD, btnL, btnR, seg, an, dp, led);

    input              clk, btnC, btnU, btnD, btnL, btnR;
    output  wire [6:0] seg;
    output  wire [3:0] an;
    output  wire       dp;
    output  wire [5:0] led;

    wire [15:0] time_reading;
    wire set, reset, trig, up, down;
    wire init_regs, count_enabled, inc, dec, min, complete;
    wire [3:0] state;

    Ctl           ctl (clk, reset, trig, set, up, down, complete, init_regs, count_enabled, inc, dec, min, state);
    Debouncer     debouncer[4:0] (clk, {btnC, btnU, btnD, btnL, btnR},{reset, up, down, set, trig});
    Counter       counter (clk, init_regs, count_enabled, inc, dec, min, time_reading, complete);
    Seg_7_Display seg_7_display (time_reading, clk, reset, seg, an, dp);
    
    assign led[0] = (state == 1) ? 1:0;
    assign led[1] = (state == 8) ? 1:0;
    assign led[2] = (state == 4) ? 1:0;
    assign led[3] = (state == 4) ? 1:0;
    assign led[4] = (state == 2) ? 1:0;
    assign led[5] = (state == 2) ? 1:0;

endmodule
