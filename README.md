# RISC-V Single-Cycle Processor Design and Verification

## Overview
This project is a 32-bit single-cycle RISC-V processor designed to execute a subset of 13 instructions. The processor is implemented using Verilog and verified with Universal Verification Methodology (UVM). The primary focus is on developing a robust verification environment and modeling the processor accurately for simulation.

> **Note:** This project is still a work in progress. Many features are not yet implemented, and existing components may require further modifications and improvements.

## Key Features
- **Processor Design:**
  - Single-cycle architecture for simplicity and performance.
  - Implements 13 RISC-V instructions:
    - `ADD`, `SUB`, `AND`, `OR`, `XOR` (R-type arithmetic operations)
    - `LW`, `SW` (load and store operations)
    - `BEQ`, `BNE` (branch operations)
    - `JAL` (jump operation)
    - `ADDI`, `ANDI`, `ORI` (I-type immediate operations)
  - Contains essential components like ALU, register file, and control unit.
  - Word-addressable 1 KB data memory (32-bit word size).

- **Verification Environment:**
  - UVM-based testbench to verify functionality.
  - Randomized instruction sequences for thorough coverage.
  - UVM Register Abstraction Layer (RAL) for register and memory modeling.
  - Backdoor access for efficient memory and register verification.

- **Testbench Highlights:**
  - Supports custom instruction sequences using virtual class-based instruction modeling.
  - Synchronizes output sampling and register/memory readback to account for single-cycle behavior.
  - Handles potential hazards and dependency scenarios in a single-cycle design without forwarding logic.

## Testbench Hierarchy
Below is the block diagram illustrating the testbench hierarchy:

![Testbench Hierarchy](Block%20diagram.png)



## Future Enhancements
- Add more instructions to extend the processor's functionality.
- Implement a pipelined version with hazard detection and forwarding logic.
- Improve verification coverage using functional coverage models.

## Contributions
Feel free to fork this repository and submit pull requests. Suggestions and improvements are always welcome!


