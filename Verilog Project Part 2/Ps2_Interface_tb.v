`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:         Eyal S
//
// Create Date:     12/12/2019 02:59:38 AM
// Design Name:    
// Module Name:     Ps2_Interface_tb
// Project Name:    Verilog Project - Part 2
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Testbench for the Ps2_Interface module.
// Dependencies:    None
//
// Revision: 		4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Ps2_Interface_tb();

    wire PS2Clk;
    reg rstn,PS2Data;

    wire [7:0] scancode;
    wire keyPressed;

    reg correct;
    reg clk, clkEn;

    integer i;

    Ps2_Interface uut (PS2Clk,rstn,PS2Data,scancode,keyPressed);

    always #5 clk = ~clk;
    assign PS2Clk = clkEn & clk;

    initial begin
        clk = 0;
        clkEn = 0;
        correct = 1;
        PS2Data = 1;
        rstn = 0;

        #10
        correct = correct & (keyPressed == 0);
        rstn = 1;

        #6
        // Sending the 9 key(=0x7D), for minimal period:
        clkEn = 1;
        send_code(8'h7D); //make
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h7D);
        send_code(8'hF0); // key up
        send_code(8'h7D); // break
        correct = correct & (keyPressed == 0);
        clkEn = 0; #20

        // Sending 8 key (0x75), for some period:
        clkEn = 1;
        send_code(8'h75);
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h75);
        clkEn = 0; #10
        #30 // In reality, 100ms

        // Verify nothing changed:
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h75);

        clkEn = 1;
        send_code(8'h75);
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h75);
        clkEn = 0; #10
        #30 // In reality, 100ms

        // Verify nothing changed:
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h75);

        clkEn = 1;
        send_code(8'hF0); // key up
        send_code(8'h75); // break
        correct = correct & (keyPressed == 0);
        clkEn = 0; #10

        #30

        // Verify nothing changed:
        correct = correct & (keyPressed == 0);


        // Verify empty clock cycles don't get us out of sync
        clkEn = 1; #40
        clkEn = 0; #10

        // Verify extended keys:
        // Sending Right-Alt key (0xE0 0x11), for some period:
        clkEn = 1;
        send_code(8'hE0);
        correct = correct & (keyPressed == 0);
        send_code(8'h11);
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h11);
        clkEn = 0; #10
        #30 // In reality, 100ms

        // Verify nothing changed:
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h11);

        clkEn = 1;
        send_code(8'hE0);
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h11);
        send_code(8'h11);
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h11);
        clkEn = 0; #10
        #30 // In reality, 100ms

        // Verify nothing changed:
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h11);

        clkEn = 1;
        send_code(8'hE0);
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h11);
        send_code(8'hF0); // key up
        correct = correct & (keyPressed == 1);
        correct = correct & (scancode == 8'h11);
        send_code(8'h75); // break
        correct = correct & (keyPressed == 0);
        clkEn = 0; #10

        if (correct)
            $display("Test Passed - %m");
        else
            $display("Test Failed - %m");
        $finish;
    end

    task send_code;
    input [7:0] code;
    begin
        $display("Sending code - 0x%x with parity %d", code, ^code);

        PS2Data = 0; #10; // Start
        for ( i = 0; i < 8; i = i + 1 ) begin
            PS2Data = code[i]; #10;
        end
        PS2Data = ^code; #10; // Parity
        PS2Data = 1; #10; // Stop
    end
    endtask

endmodule
