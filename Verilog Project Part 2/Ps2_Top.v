`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:     
// Module Name:     Ps2_Top
// Project Name:   Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     top level module that instantiates ps2_insterface and ps2_display
//                  and connects to the FPGA pins.
// Dependencies:    None
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Ps2_Top(clk, btnC, PS2Clk, PS2Data, seg, an, dp, led);
    input clk,btnC,PS2Clk,PS2Data;
    output wire [6:0] seg;
    output wire [3:0] an;
    output wire dp;
    output wire led;
    wire keyPressed;
    wire [7:0] scancode;

    Ps2_Interface ps2_interface(PS2Clk, ~btnC, PS2Data, scancode, keyPressed);
    Ps2_Display ps2_display(clk, ~btnC, keyPressed, scancode, seg, an, dp, led);

endmodule
