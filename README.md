# Hardware-Verilog-Based-Implementation-of-Matrix-Multiplication-Using-Control-&-Datapath-Architecture
This project presents a fully hardware-implemented 4×4 matrix multiplier designed in Verilog HDL, built using a structured multi-stage architecture inspired by real digital processing pipelines. The design follows a modular approach consisting of an Instruction Unit (IU), Control Unit (CU), Datapath Unit (DU), and Memory Modules, all working in synchronization to execute matrix operations efficiently at the RTL level.

At the core of the design is an FSM-driven control system, where the Control Unit is modeled using an Algorithmic State Machine (ASM) framework to control each stage of the computation. This enables a clean separation between control flow and data processing, ensuring a clean execution of multiply-accumulate operations across sequential states.

The datapath is designed to support synchronous RTL computation, handling matrix element loading, intermediate accumulation, and result storage through a controlled memory interface. The architecture emphasizes hardware-level parallelism, structured state transitions, and  timing control, closely resembling the behavior of simplified processing units used in real hardware accelerators.

Key engineering concepts demonstrated include:

RTL design using Verilog HDL
FSM / ASM based control and Datapath unit design
Multi-stage hardware architecture
Memory interfacing and address management
Modular system decomposition
Simulation-driven verification of digital systems

The system was fully verified using simulation, ensuring correct functional behavior and accurate matrix output generation across all computation stages.

How to Run the Project

To simulate and test the design:

Open your Verilog simulation environment (e.g., Altera Quartus).
Set matrix_mult_top.v as the Top-Level Module (Top Repository).
Set matrix_mult_top_tb.v as the Testbench file.
Run Synthesis / Analysis to compile the design.
Launch RTL Simulation to observe the full matrix multiplication process and view waveform outputs.
