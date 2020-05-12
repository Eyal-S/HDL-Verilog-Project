`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        
// Engineer:         Eyal S
//
// Create Date:     12/1/2019 02:59:38 AM
// Design Name:     
// Module Name:     VGA_Top
// Project Name:    Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Top module for the VGA task.
// Dependencies:    Ps2_Interface.v, VGA_Interface.v, Color_Constructor.v
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module VGA_Top(clk, PS2Clk, PS2Data, btnC, Hsync, Vsync, vgaRed, vgaGreen, vgaBlue, led );
    input clk,PS2Clk,PS2Data,btnC;

    output wire Hsync, Vsync;
    output wire [3:0] vgaRed;
    output wire [3:0] vgaGreen;
    output wire [3:0] vgaBlue;
    output wire [2:0] led;

    wire keyPressed;
    wire [7:0] scancode;
    wire [11:0] pixel_color;
    wire [9:0] XCoord;
    wire [9:0] YCoord;

    Ps2_Interface ps2_interface (PS2Clk, ~btnC, PS2Data, scancode, keyPressed);
    Color_Constructor c_c (clk, ~btnC, keyPressed, scancode, pixel_color, led);
    VGA_Interface VGA_Interface(clk, ~btnC, pixel_color, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync, XCoord, YCoord);

endmodule
