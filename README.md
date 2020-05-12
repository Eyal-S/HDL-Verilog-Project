# HDL-Verilog-Project
Verilog project written in Vivado

# Verilog Project Part 1 - 

* The purpose of the first part of the project is to cover the following topics:

1. Basic design and simulation in Verilog:
  a. Registers and wires
  b. Combinational logic - continuous assignments and always@ blocks
  c. Synchronous logic - always@ blocks, finite state machines
  d. Module description and instantiation, parameterized modules
  e. Verifying design by test-benches

2. FPGA Design Flow in Xilinx Environment:
  a. RTL Design 
  b. Simulation – writing a test-bench and debugging using wave-diagrams
  c. Synthesis, Implementation and the constraints file (.xdc)
  d. Timing analysis (setup, hold, slack)
  e. Interfacing the peripheral components of the BASYS3 board
  f. Integrated Logic Analyzer usage for hardware debugging

3. Engineering issues:
  a. Specification understanding, signed addition, finite state machines
  b. Digital debouncing and pulse generation
  c. Clock, frequency division

For part 1 I have created the following modules:  
Full Adder, Binary Adder, Incrementor-Decrementor, Counter, 
Control, Debouncer, Seven Segment Display, Countdown and some test-benches. 


# Verilog Project Part 2 - 

* The purpose of the second part of the project is to cover the following topics:

1. Asynchronous reset
2. PS2 interface - serial data transfer, transmission-frame structure, not a constantly toggling clock, how to identify an event of key-press
3. Video Graphics Array (VGA) interface – synchronization signals, color space encoding

For part 2 I have created the following modules:  
VGA_Interface.v, VGA_Interface_tb.v, Color_Constructor.v, VGA_Top.v, task2.xdc
Ps2_Interface.v, Ps2_Interface_tb.v, Ps2_Display.v, Ps2_Top.v, task1.xdc
