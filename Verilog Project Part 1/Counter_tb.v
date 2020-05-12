`timescale 1 ns / 1 ns
`define CLK_FREQ_TB 20
//////////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:        Eyal S
//
// Create Date:     12/12/2019 00:00:00  AM
// Design Name:     
// Module Name:     Counter_tb
// Project Name:   Verilog Part 1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     test bench for Counter module
// Dependencies:    Counter
//
// Revision:        4.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module Counter_tb();

    reg clk, init_regs, count_enabled, correct, loop_was_skipped;
    wire [15:0] time_reading;
    wire [3:0] tens_seconds_wire;
    wire [3:0] ones_seconds_wire;
    wire [3:0] tens_minutes_wire;
    wire [3:0] ones_minutes_wire;
    integer total_sec;
    wire complete;
    reg inc, dec, min;

    // Instantiate the UUT (Unit Under Test)
    // TODO - Instantiation
    Counter #(`CLK_FREQ_TB) uut (clk, init_regs, count_enabled, inc, dec, min, time_reading, complete);

    assign tens_seconds_wire = time_reading[7:4];
    assign ones_seconds_wire = time_reading[3:0];
    assign ones_minutes_wire = time_reading[11:8];
    assign tens_minutes_wire = time_reading[15:12];

    initial begin
        #1
        correct = 1;
        loop_was_skipped = 1;
        clk = 1;
        init_regs = 1;
        count_enabled = 0;
        
        inc = 0;
        dec = 0;
        min = 0;
        
        total_sec = 0;
        
        #10
        
        init_regs = 0;
        // Incrementing 75 seconds:
        min = 0;
        inc = 1;
        #(10*65)
        total_sec = total_sec + 65;
        // Incrementing 2 minutes
        min = 1;
        inc = 1;
        #(10*2)
        total_sec = total_sec + 2*60;
        // Decrementing 5 seconds:
        min = 0;
        inc = 0;
        dec = 1;
        #(10*10)
        total_sec = total_sec - 10;
        
        inc = 0;
        dec = 0;
              
        count_enabled = 1;
        // Every CLK_FREQ_TB clocks are 1 second
        for( ; total_sec>1; total_sec=total_sec-1 ) begin 
            $display("total_sec=%0d, ones_sec=%0d, tens_sec=%0d, ones_min=%0d, tens_min=%0d",
                total_sec,
                (total_sec % 60) % 10,
                (total_sec % 60) / 10,
                (total_sec / 60) % 10,
                (total_sec / 60) / 10);
            $display("               ones_sec=%0d, tens_sec=%0d, ones_min=%0d, tens_min=%0d",
                ones_seconds_wire,
                tens_seconds_wire,
                ones_minutes_wire,
                tens_minutes_wire);
                
            correct = correct & (ones_seconds_wire == ((total_sec % 60) % 10));
            correct = correct & (tens_seconds_wire == ((total_sec % 60) / 10));

            correct = correct & (ones_minutes_wire == ((total_sec / 60) % 10));
            correct = correct & (tens_minutes_wire == ((total_sec / 60) / 10));
            #(`CLK_FREQ_TB*10)
                                   
            loop_was_skipped = 0;
        end
        correct = correct & (complete == 1);
        #(`CLK_FREQ_TB*10)
        correct = correct & (time_reading == 0); 
        #2       
        correct = correct & (complete == 0);
        #(`CLK_FREQ_TB*10)
                    
        #5
        if (correct && ~loop_was_skipped)
            $display("Test Passed - %m");
        else
            $display("Test Failed - %m");
        $finish;
    end

    always #5 clk = ~clk;
endmodule
