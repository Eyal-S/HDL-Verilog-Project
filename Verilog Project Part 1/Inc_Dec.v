`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:      
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 00:16 AM
// Design Name:     
// Module Name:     Inc_Dec
// Project Name:    Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Incrementor/Decrementor modulo L.
//                  Let z be the desired sum: z = a + inc - dec
//                  If z >= L, then the output will be s=0,co=1
//                  If z < 0, then the output will be s=L-1,co=1
//                  If 0 <= z <= L-1 then the output will be s=z,co=0.
//
// Dependencies:    Adder
//
// Revision:        4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Inc_Dec(a, inc, dec, sum, overflow, underflow);

    parameter L = 10;    
    parameter N = $clog2(L);

    input [N-1:0] a;
    input inc, dec;
    output [N-1:0] sum;
    output overflow, underflow;
    
    wire [N-1:0] dec_val;
    wire [N-1:0] z;
    wire z_co;
    
    Adder #(N) adder (a, dec_val, inc, z, z_co);
    
    assign dec_val = dec ? ~0 : 0;
    
    assign underflow = (a == 0) && dec && !inc;
    assign overflow = ~underflow & ((z >= L) | (z_co & ~dec));
    
    assign sum = overflow ? 0 : (underflow ? L - 1 : z);

endmodule
