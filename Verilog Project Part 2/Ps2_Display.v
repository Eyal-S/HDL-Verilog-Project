`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:     
// Module Name:   Color_Constructor
// Project Name:    Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     The module operates the 7-segment display and the user LED to provide visual
//                  feedback of the input inspected by the Ps2_Interface module.
// Dependencies:    None
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Ps2_Display(clk,rstn,keyPressed,scancode,seg,an,dp,led);


    input clk,rstn,keyPressed;
    input [7:0]scancode;
    output reg [6:0] seg;
    output wire dp;
    output reg [3:0] an;
    output wire led;

    wire s;
    reg [18:0] clkdiv;
    reg [3:0] digit;
    reg [25:0] led_en;

    assign s = clkdiv[18];
    assign dp = (digit == 'hB | digit == 'hD) ? 0 : 1;           // dot indicator
    always @(posedge clk) begin
        case(s)
            0:digit <= scancode[3:0];
            1:digit <= scancode[7:4];
            default:digit <= scancode[3:0];
        endcase
    end
    integer i;
    integer count = 1;
    always @(*)
       case(digit)
           //////////<---MSB-LSB<---/////
           //////////////gfedcba/////////                       a
           0:seg = 7'b1000000;////0000                      __
           1:seg = 7'b1111001;////0001                   f/   /b
           2:seg = 7'b0100100;////0010                     g
         //                                               __
           3:seg = 7'b0110000;////0011                e /   /c
           4:seg = 7'b0011001;////0100                  __
           5:seg = 7'b0010010;////0101                  d
           6:seg = 7'b0000010;////0110
           7:seg = 7'b1111000;////0111
           8:seg = 7'b0000000;////1000
           9:seg = 7'b0010000;////1001
           'hA:seg = 7'b0001000;
           'hB:seg = 7'b0000000;
           'hC:seg = 7'b1000110;
           'hD:seg = 7'b1000000;
           'hE:seg = 7'b0000110;
           'hF:seg = 7'b0001110;
           default: seg = 7'b0000000; // U
       endcase
    always @(*)begin
        an=4'b1111;
        an[s] = 0;
    end
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
           clkdiv <= 0;
           led_en <= 0;
        end
        else begin
            clkdiv <= clkdiv + 1;
           // count = 1;
            if (keyPressed) begin
                    led_en <= 25000000;
            end
            else if (led_en > 0)
                led_en <= led_en - 1;

        end
    end
    assign led = led_en != 0;

endmodule


