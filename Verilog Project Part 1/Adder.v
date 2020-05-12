`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         
// Engineer:           Eyal S
//
// Create Date:     12/12/2019 08:59:38 PM
// Design Name:     
// Module Name:     Adder
// Project Name:    Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Variable length binary adder. The parameter N determines
//                  the bit width of the operands.
//
// Dependencies:    FA
//
// Revision         4.0 - File Created
//////////////////////////////////////////////////////////////////////////////////
module Adder(a, b, ci, sum, co);

    parameter N=4;

    input [N-1:0] a;
    input [N-1:0] b;
    input ci;
    output [N-1:0] sum;
    output co;

    wire [N:1] c_out;

    FA adderArr[N-1:0](a, b, {c_out[N-1:1], ci}, sum, c_out[N:1]);
    assign co = c_out[N];

endmodule
