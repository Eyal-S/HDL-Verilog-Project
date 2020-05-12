`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 08:59:38 PM
// Design Name:     
// Module Name:     FA
// Project Name:   Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Well known full adder
//
// Dependencies:    None
//
// Revision:        4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module FA(a, b, ci, sum, co);

  input   a, b, ci;
  output  sum, co;

  wire a_xor_b, net, a_and_b;

  xor (a_xor_b, a, b);
  xor (sum, a_xor_b, ci);
  and (a_and_b, a, b);
  and (net, a_xor_b, ci);
  or (co, net, a_and_b);


endmodule
