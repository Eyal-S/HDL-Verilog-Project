`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:     
// Module Name:     Color_Constructor
// Project Name:    Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     VGA Color Constructor.
// Dependencies:    None
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Color_Constructor(clk,rstn,keypressed,scancode,pixel_color, state);

    input clk, rstn, keypressed;
    input [7:0] scancode;
    
    output reg [2:0] state;
    reg [3:0] red;
    reg [3:0] green;
    reg [3:0] blue;
    
    output reg [11:0] pixel_color;
    
    always @(posedge clk or negedge rstn) begin
        if (rstn == 0) begin
            pixel_color <= 12'hfff;
            state <= 0;
        end else if ((state == 0) & keypressed) begin
            red <= key_to_color(scancode);
            state <= 1;
        end else if ((state == 1) & ~keypressed) begin
            state <= 2;
        end else if ((state == 2) & keypressed) begin
            green <= key_to_color(scancode);
            state <= 3;
        end else if ((state == 3) & ~keypressed) begin
            state <= 4;
        end else if ((state == 4) & keypressed) begin
            blue <= key_to_color(scancode);
            state <= 5;
        end else if ((state == 5) & ~keypressed) begin
            state <= 6;
        end else if (state == 6) begin
            if (keypressed) begin
                if  (scancode == 8'h5a) begin
                    state <= 7;
                    pixel_color <= {blue, green, red};
                end else begin
                    state <= 7;
                end
            end
        end else if ((state == 7) & ~keypressed) begin
            state <= 0;
        end
    end
   
    function [3:0] key_to_color;
    input [7:0] sc;
    begin
        case (sc)
            8'h75 : key_to_color = 15;
            8'h6C : key_to_color = 14;
            8'h74 : key_to_color = 12;
            8'h73 : key_to_color = 10;
            8'h6B : key_to_color = 8;
            8'h7A : key_to_color = 6;
            8'h72 : key_to_color = 4;
            8'h69 : key_to_color = 2;
            8'h70 : key_to_color = 0;
            default : key_to_color = 0;
        endcase
    end
    endfunction

endmodule
