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

![Testbench Hierarchy](Block%20diagram.png)

## Functional Coverage Plan

The functional coverage plan ensures thorough testing of the processor by covering key functional aspects, including instructions, control flow, registers, memory operations, and reset behavior.

### **1. Instruction Coverage**
- **Objective:** Ensure all instruction types and sequences are exercised.
- **Coverpoints:**
  - `instruction_cp`:
    - R-type instructions: `ADD`, `SUB`, `AND`, `OR`.
    - I-type instructions: `ADDI`, `ANDI`, `ORI`, `LW`, `JALR`.
    - J-type instructions: `JAL`.
    - S-type instructions: `SW`.
    - B-type instructions: `BEQ`, `BNE`.
    - Illegal instructions: `UNKNOWN`.

- **Control Flow Coverage:**
  - Sequences of instruction execution:
    - R-type after R-type.
    - R-type after I-type.
    - Branch after compute, load after compute.
    - Store after load, load after store.
    - Branch after branch, jump after branch, etc.

### **2. Register Coverage**
- **Objective:** Ensure all registers (`rs1`, `rs2`, `rd`) are accessed.
- **Coverpoints:**
  - `rs1_cp`, `rs2_cp`, `rd_cp`:
    - All 32 registers accessed.

- **Cross Coverage:**
  - R-type instructions with `rs1`, `rs2`, `rd`.
  - I-type instructions with `rs1`, `rd`.
  - Immediates with specific instruction types (e.g., `I_imm` with I-type).

### **3. Immediate Value Coverage**
- **Objective:** Ensure immediate values are thoroughly exercised for all instruction types.
- **Coverpoints:**
  - `I_imm_cp`, `S_imm_cp`, `B_imm_cp`, `J_imm_cp`:
    - Zero values.
    - Positive ranges (split into bins for granularity).
    - Negative ranges (split into bins for granularity).

- **Cross Coverage:**
  - Each instruction type with its associated immediate values:
    - `I_imm_cp` with I-type instructions.
    - `S_imm_cp` with S-type instructions.
    - `B_imm_cp` with B-type instructions.
    - `J_imm_cp` with J-type instructions.

### **4. Program Counter (PC) Coverage**
- **Objective:** Ensure PC operates within the expected boundaries and wraps around correctly.
- **Coverpoints:**
  - `PC_max_cp`:
    - Boundary conditions: `0x0`, `0xFFFF_FFFC`.
    - Wraparound from `0xFFFF_FFFC` to `0x0`.

### **5. Memory Operations Coverage**
- **Objective:** Validate memory write/read operations, patterns, and data values.
- **Coverpoints:**
  - `MemWrite_cp`:
    - Write operations, read operations.
    - Write and read bursts (4 consecutive).
  - `DataAdr_cp`:
    - Specific memory locations: First (`0x00`), last (`0xFF`).
    - Memory ranges: Lower quarter, middle half, upper quarter.
    - Sequential access patterns.
  - `WriteData_cp`:
    - Common patterns: Zero, all-ones, alternating bits (`0xAAAA_AAAA`, `0x5555_5555`).
    - Default values.
  - `ReadData_cp`:
    - Common patterns: Zero, all-ones, alternating bits (`0xAAAA_AAAA`, `0x5555_5555`).
    - Default values.

- **Cross Coverage:**
  - Write/read operations with data addresses.
  - Write data and addresses during write operations.
  - Read data and addresses during read operations.

### **6. Reset Coverage**
- **Objective:** Ensure reset signal is correctly toggled.
- **Coverpoints:**
  - `reset_active`:
    - Reset active.
    - Reset inactive.

## Future Enhancements
- Add more instructions to extend the processor's functionality.
- Implement a pipelined version with hazard detection and forwarding logic.
- Improve verification coverage using functional coverage models.

## Contributions
Feel free to fork this repository and submit pull requests. Suggestions and improvements are always welcome!
