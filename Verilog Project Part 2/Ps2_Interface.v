`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:      
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:     
// Module Name:     Ps2_Interface
// Project Name:   Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     interface with the keyboard and outputting the most recently pressed 8-bit scan-code
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Ps2_Interface(PS2Clk,rstn,PS2Data,scancode,keyPressed);

    input PS2Clk, rstn, PS2Data;
    output reg [7:0] scancode;
    output wire keyPressed;


    reg state;
    reg [2:0] debug;
    wire [7:0] curCode;
    wire       curCodeParity;
    wire [7:0] prevCode;
    wire       prevCodeParity;


    localparam IDLE = 1'b0;
    localparam PRESSED = 1'b1;

    assign keyPressed = state;
    assign curCode = R[20:13];
    assign curCodeParity = R[21];
    assign prevCode = R[9:2];
    assign prevCodeParity = R[10];

    reg [21:0] R;
    reg [3:0] count;

    always @(negedge PS2Clk or negedge rstn) begin
        if (~rstn) begin
            scancode <= 0;
            count <= 0;
            state <= IDLE;
            R <= 22'h0;
            debug <= 5;
        end else begin

            if (count == 10) begin
                if (state == IDLE) begin
                    if (is_equal(curCode, curCodeParity, 8'hE0)) begin
                        // extended key modifier
                        debug <= 1;
                    end else if (^curCode == ~curCodeParity) begin
                        state <= PRESSED;
                        scancode <= curCode;
                        debug <= 2;
                    end else begin
                        debug <= 3;
                    end

                end else begin // state == PRESSED
                    // check for key release:
                    if (is_equal(prevCode, prevCodeParity, 8'hF0)) begin
                        state <= IDLE;
//                        scancode <= 8'b0;
                        debug <= 6;
                    end else
                        debug <=7;
                end
            end else begin
                debug <= 4;
            end

            // Shift register (reversed from the one specified in the theoretical background):
            R[21:0] <= {PS2Data, R[21:1]};
            if (count >= 10)
                count <= 0;
            else if (count == 0)
                count <= 1;//(PS2Data == 0) ? 1 : 0; // wait to start bit
            else
                count = count + 1;
        end

    end

    function is_equal;
    input [7:0] a;
    input parity;
    input [7:0] b;
    begin
        is_equal = (a == b) && (~parity == ^b);
    end
    endfunction

endmodule
