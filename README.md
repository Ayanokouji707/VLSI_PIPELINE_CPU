# VLSI_Pipeline_CPU
# 4-Stage Pipelined CPU in Verilog
This project implements a **4-Stage Pipelined CPU** in Verilog with a comprehensive testbench.  
It demonstrates fundamental concepts of **instruction pipelining** and **processor design**.

---

## 📂 Files Included
- **PipelineCPU.v** → Main CPU module with 4-stage pipeline  
- **PipelineCPU_tb.v** → Testbench with sample program execution  
- **README.md** → This documentation file  

---

## ⚙️ Features
- **4-Stage Pipeline**: IF → ID → EX → WB  
- **32-bit data path** with 8 general-purpose registers  
- **16-bit instruction format** with 16 instruction memory capacity  
- **Instruction Set**: LOAD, ADD, SUB, NOP operations  
- **Debug interface** for monitoring internal registers and PC  

---

## 🏗️ Architecture

### Pipeline Stages
```
┌─────┐    ┌─────┐    ┌─────┐    ┌─────┐
│ IF  │───▶│ ID  │───▶│ EX  │───▶│ WB  │
└─────┘    └─────┘    └─────┘    └─────┘
```

### Instruction Set
| Opcode | Instruction | Format | Description |
|--------|-------------|--------|-------------|
| 0000   | NOP         | -      | No operation |
| 0001   | LOAD Rd, imm| [4:op][4:rd][8:imm] | Load immediate into register |
| 0010   | ADD Rd, Rs, Rt | [4:op][4:rd][4:rs][4:rt] | Add two registers |
| 0011   | SUB Rd, Rs, Rt | [4:op][4:rd][4:rs][4:rt] | Subtract two registers |

---

## 📝 Simulation Results

### Sample Program
```assembly
LOAD R1, 5      ; Load immediate value 5 into R1
LOAD R2, 10     ; Load immediate value 10 into R2  
ADD R3, R1, R2  ; R3 = R1 + R2 (5 + 10 = 15)
SUB R4, R3, R1  ; R4 = R3 - R1 (15 - 5 = 10)
NOP             ; No operation
```

### Execution Log
```
Starting Pipeline CPU Simulation...
TIME=5000  | PC=0 | Instr=xxxx | R1=0 R2=0 R3=0 R4=0
TIME=15000 | PC=0 | Instr=1105 | R1=0 R2=0 R3=0 R4=0
EXEC: LOAD R1 <- 5
TIME=25000 | PC=1 | Instr=120a | R1=0 R2=0 R3=0 R4=0
EXEC: LOAD R2 <- 10
TIME=35000 | PC=2 | Instr=2312 | R1=5 R2=0 R3=0 R4=0
EXEC: ADD R3 <- R1 + R2
TIME=45000 | PC=3 | Instr=3431 | R1=5 R2=10 R3=0 R4=0
EXEC: SUB R4 <- R3 - R1
TIME=55000 | PC=4 | Instr=0000 | R1=5 R2=10 R3=15 R4=0
TIME=65000 | PC=5 | Instr=0000 | R1=5 R2=10 R3=15 R4=10
Simulation completed.
```

---

## 🚀 Running the Simulation

### Using Vivado
```tcl
# Create new project
create_project pipeline_cpu ./pipeline_cpu -part xc7a35tcpg236-1

# Add source files
add_files -norecurse {PipelineCPU.v PipelineCPU_tb.v}

# Set testbench as simulation source
set_property top PipelineCPU_tb [get_filesets sim_1]

# Run behavioral simulation
launch_simulation
run all
```

### Alternative Simulators
```bash
# Using ModelSim
vlog PipelineCPU.v PipelineCPU_tb.v
vsim -c PipelineCPU_tb -do "run -all; quit"

# Using Icarus Verilog  
iverilog -o pipeline_cpu PipelineCPU.v PipelineCPU_tb.v
vvp pipeline_cpu
```

---

## 📌 Applications
- **Digital design education** - Understanding CPU pipelining concepts
- **FPGA/ASIC prototyping** - Basic processor implementation  
- **Computer architecture learning** - Instruction execution flow
- **Verilog design reference** - Clocked sequential logic examples

---

## 🧑‍💻 Author
- **Saurabh Kamble**  
- **[https://github.com/Ayanokouji707](https://github.com/Ayanokouji707)**
