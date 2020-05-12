`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 08:59:38 PM
// Design Name:     
// Module Name:     Ctl
// Project Name:   Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Control module that receives reset,trig and split inputs from the buttons
//                  outpputs the init_regs and count_enabled level signals that should govern the
//                  operation of the Counter module.
// Dependencies:    None
//
// Revision:  	    4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Ctl(clk, reset, trig, set, up, down, complete, init_regs, count_enabled, inc, dec, min, state);

   input clk, reset, trig, set, up, down, complete;
   output init_regs, count_enabled, inc, dec, min, state;
   //-------------Internal Constants--------------------------
   localparam SIZE = 4;
   localparam IDLE = 1, PAUSED_SETMIN = 2, PAUSED_SETSEC = 4 , COUNTING = 8;
   reg [SIZE-1:0] 	  state;
   
   wire set_sec_min;

   //-------------Transition Function (Delta) ----------------
   always @(posedge clk)
     begin
        if (reset)
            state <= IDLE;
        else
            case (state)
            IDLE :
                if (set)
                    state <= PAUSED_SETMIN;
            PAUSED_SETMIN :
                if (trig)
                    state <= COUNTING;
                else if (set)
                    state <= PAUSED_SETSEC;
            PAUSED_SETSEC :
                if (trig)
                    state <= COUNTING;
                else if (set)
                    state <= PAUSED_SETMIN;
            COUNTING:
                if (complete)
                    state <= IDLE;
                else if (trig)
                    state <= PAUSED_SETMIN;
            endcase
     end

   //-------------Output Function (Lambda) ----------------
	 assign init_regs      = (state == IDLE);
	 assign count_enabled  = (state == COUNTING) & (~complete) & (~trig);
	 assign set_sec_min    = (state == PAUSED_SETMIN) | (state == PAUSED_SETSEC);  
	 assign inc            = set_sec_min ? up : 0; 
     assign dec            = set_sec_min ? down : 0;
     assign min            = (state == PAUSED_SETMIN);

endmodule
