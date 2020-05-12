`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         
// Engineer:          Eyal S
//
// Create Date:     12/12/2019 00:19 AM
// Design Name:     
// Module Name:     Counter
// Project Name:   Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     a counter that decreases its count as long as time_reading
//                  signal is high and zeroes its reading upon init_regs=1 input.
//                  the time_reading output represents:
//                  {tens of minutes, minutes,tens of seconds, seconds}
// Dependencies:    Inc Dec
//
// Revision         4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Counter(clk, init_regs, count_enabled, inc, dec, min, time_reading, complete);

   parameter CLK_FREQ = 100000000;// in Hz

   input clk, init_regs, count_enabled, inc, dec, min;
   output [15:0] time_reading;
   output reg complete;

   reg [$clog2(CLK_FREQ)-1:0] clk_cnt;
   reg [3:0] ones_seconds;
   reg [2:0] tens_seconds;
   reg [3:0] ones_minutes;
   reg [2:0] tens_minutes;

   assign time_reading = {{1'b0,tens_minutes}, ones_minutes, {1'b0,tens_seconds}, ones_seconds};

   // FILL HERE THE INC_DEC INSTANCES
   wire ones_sec_inc, ones_sec_dec;
   wire ones_sec_of, ones_sec_uf;
   wire tens_sec_of, tens_sec_uf;
   wire ones_min_inc, ones_min_dec;
   wire ones_min_of, ones_min_uf;
   wire tens_min_of, tens_min_uf;
   
   wire [3:0] ones_sec_new;
   wire [2:0] tens_sec_new;
   wire [3:0] ones_min_new;
   wire [2:0] tens_min_new;
   
   Inc_Dec #(10) ones_sec_inc_dec (ones_seconds, ones_sec_inc, ones_sec_dec, ones_sec_new, ones_sec_of, ones_sec_uf);
   Inc_Dec #(6)  tens_sec_inc_dec (tens_seconds, ones_sec_of,  ones_sec_uf,  tens_sec_new, tens_sec_of, tens_sec_uf);
   Inc_Dec #(10) ones_min_inc_dec (ones_minutes, ones_min_inc, ones_min_dec, ones_min_new, ones_min_of, ones_min_uf);
   Inc_Dec #(6)  tens_min_inc_dec (tens_minutes, ones_min_of,  ones_min_uf,  tens_min_new, tens_min_of, tens_min_uf);
   
   assign ones_sec_inc = (~min & inc);
   assign ones_sec_dec = (~min & dec) | count_enabled;
     
   assign ones_min_inc = ( min & inc) | tens_sec_of;
   assign ones_min_dec = ( min & dec) | tens_sec_uf;
   
   //------------- Synchronous ----------------
   always @(posedge clk) begin
        if (init_regs) begin
            ones_seconds <= 0;
            tens_seconds <= 0;
            ones_minutes <= 0;
            tens_minutes <= 0;
            clk_cnt <= CLK_FREQ - 1;
        end else if (count_enabled) begin
            if (clk_cnt == 0) begin
                clk_cnt <= CLK_FREQ - 1;
                ones_seconds <= ones_sec_new;
                tens_seconds <= tens_sec_new;
                ones_minutes <= ones_min_new;
                tens_minutes <= tens_min_new;
            end else begin
                clk_cnt <= clk_cnt - 1;
            end
        end else if (inc | dec) begin
            ones_seconds <= ones_sec_new;
            tens_seconds <= tens_sec_new;
            ones_minutes <= ones_min_new;
            tens_minutes <= tens_min_new;
        end
        
        complete <= (time_reading == 16'h0000) & count_enabled;
     end

endmodule
