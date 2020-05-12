`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/1/2019 02:59:38 AM
// Design Name:     
// Module Name:     VGA_interface_tb
// Project Name:    Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     test bennch for the VGA interface.
// Dependencies:    VGA_Interface.v
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module VGA_interface_tb();

    reg clk, rstn;
    reg [11:0] pixel_color;

    wire Hsync, Vsync;
    wire [3:0] vgaRed;
    wire [3:0] vgaGreen;
    wire [3:0] vgaBlue;
    wire [9:0] XCoord;
    wire [9:0] YCoord;

    reg correct;

    integer xi, yi, ti;
    reg [9:0] x;
    reg [9:0] y;


    VGA_Interface uut (clk,rstn,pixel_color,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync,XCoord,YCoord);

    initial begin
        correct = 1;
        clk = 0;
        rstn = 0;
        #40

        rstn = 1;
        pixel_color = {4'ha,4'hb,4'hc};

        #40
        #4

        for( ti=0; ti<3; ti=ti+1 ) begin

            for( yi=0; yi<525; yi=yi+1 ) begin
                for( xi=0; xi<800; xi=xi+1 ) begin
                    x = xi; y = yi;
                    correct = correct & (x == XCoord);
                    correct = correct & (y == YCoord);
                    if (x > 658 && x < 756)
                        correct = correct & ~Hsync;
                    else
                        correct = correct & Hsync;

                    if (y > 492 && y < 495)
                        correct = correct & ~Vsync;
                    else
                        correct = correct & Vsync;

                    if (x > 639 || y > 479 ) begin
                        correct = correct & (vgaRed == 0);
                        correct = correct & (vgaGreen == 0);
                        correct = correct & (vgaBlue == 0);
                    end else begin
                        correct = correct & (vgaRed == pixel_color[3:0]);
                        correct = correct & (vgaGreen == pixel_color[7:4]);
                        correct = correct & (vgaBlue == pixel_color[11:8]);
                    end

                    #40;
                end
            end

        end

        if (correct)
            $display("Test Passed - %m");
        else
            $display("Test Failed - %m");
        $finish;
    end

    always #5 clk = ~clk;

endmodule
