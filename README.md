# HDL-Verilog-Project
Verilog project written in Vivado

# Verilog Project Part 1 - 

__The purpose of the first part of the project is to cover the following topics:__

1. Basic design and simulation in Verilog:
  * Registers and wires
  * Combinational logic - continuous assignments and always@ blocks
  * Synchronous logic - always@ blocks, finite state machines
  * Module description and instantiation, parameterized modules
  * Verifying design by test-benches

2. FPGA Design Flow in Xilinx Environment:
  * RTL Design 
  * Simulation – writing a test-bench and debugging using wave-diagrams
  * Synthesis, Implementation and the constraints file (.xdc)
  * Timing analysis (setup, hold, slack)
  * Interfacing the peripheral components of the BASYS3 board
  * Integrated Logic Analyzer usage for hardware debugging

3. Engineering issues:
  * Specification understanding, signed addition, finite state machines
  * Digital debouncing and pulse generation
  * Clock, frequency division

For part 1 I have created the following modules:  
Full Adder, Binary Adder, Incrementor-Decrementor, Counter, 
Control, Debouncer, Seven Segment Display, Countdown and some test-benches. 


# Verilog Project Part 2 - 

__The purpose of the second part of the project is to cover the following topics:__

1. Asynchronous reset
2. PS2 interface - serial data transfer, transmission-frame structure, not a constantly toggling clock, how to identify an event of key-press
3. Video Graphics Array (VGA) interface – synchronization signals, color space encoding

For part 2 I have created the following modules:  
VGA_Interface.v, VGA_Interface_tb.v, Color_Constructor.v, VGA_Top.v, task2.xdc
Ps2_Interface.v, Ps2_Interface_tb.v, Ps2_Display.v, Ps2_Top.v, task1.xdc
