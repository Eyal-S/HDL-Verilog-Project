`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:   
// Module Name:     VGA_Interface
// Project Name:   Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Interface for the VGA display
// Dependencies:    None
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module VGA_Interface(clk,rstn,pixel_color,vgaRed,vgaGreen,vgaBlue,Hsync,Vsync,XCoord,YCoord);

    input clk, rstn;
    input [11:0] pixel_color;

    output reg Hsync, Vsync;
    output reg [3:0] vgaRed;
    output reg [3:0] vgaGreen;
    output reg [3:0] vgaBlue;
    output wire [9:0] XCoord;
    output wire [9:0] YCoord;

    reg [1:0] clk_div;
    reg [9:0] hcount;
    reg [9:0] vcount;

    always @(posedge clk)begin
        if (rstn)
            clk_div <= clk_div + 1;
    end

    always @(posedge clk_div[1] or negedge rstn) begin
        if (~rstn) begin
            hcount <= 799;
            vcount <= 524;
            vgaRed <= 4'hf;
            vgaGreen <= 4'hf;
            vgaBlue <= 4'hf;
            Hsync <= 0;
            Vsync <= 0;
            //clk_div <= 2'b10;
        end else begin
            if (((vcount < 480) && (hcount < 639)) || ((vcount < 479) && (hcount == 799)) || ((vcount == 524) && (hcount == 799))) begin
                vgaRed <= pixel_color[3:0];
                vgaGreen <= pixel_color[7:4];
                vgaBlue <= pixel_color[11:8];
            end else begin
                vgaRed <= 0;
                vgaGreen <= 0;
                vgaBlue <= 0;
            end

            if ((hcount >= 658) & (hcount < 755))
                Hsync <= 0;
            else
                Hsync <= 1;

            if (((vcount == 492) && (hcount >= 799)) || (vcount == 493) || ((vcount == 494) && (hcount < 799)))
                Vsync <= 0;
            else
                Vsync <= 1;

            if (hcount >= 799) begin
                hcount <= 0;
                vcount <= vcount+1;
                if (vcount >= 524) begin
                    vcount <= 0;
                end else begin
                    vcount <= vcount+1;
                end
            end else begin
                hcount <= hcount + 1;
            end

        end
    end

    assign XCoord = hcount;
    assign YCoord = vcount;
endmodule
