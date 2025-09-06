`timescale 1ns/1ps
module PipelineCPU #(parameter WIDTH=32, DEPTH=16)(
    input clk,
    input reset
);

  // === Program Counter ===
  reg [WIDTH-1:0] PC;

  // === Instruction Memory (16 instructions) ===
  reg [15:0] instr_mem [0:DEPTH-1];

  // === Register File (8 registers) ===
  reg [WIDTH-1:0] regfile [0:7];

  // === Pipeline registers ===
  reg [15:0] IF_instr;
  reg [3:0]  ID_op, ID_rd, ID_rs, ID_rt;
  reg [7:0]  ID_imm;

  reg [3:0]  EX_op, EX_rd, EX_rs, EX_rt;
  reg [7:0]  EX_imm;

  reg [3:0]  WB_op, WB_rd;
  reg [WIDTH-1:0] WB_val;

  integer r;

  // === Initialize program and regfile ===
  initial begin
    // Clear registers
    for (r = 0; r < 8; r = r + 1) begin
      regfile[r] = 0;
    end
    PC = 0;

    // Program:
    // LOAD R1, 5
    instr_mem[0] = 16'h1105;
    // LOAD R2, 10
    instr_mem[1] = 16'h120A;
    // ADD R3 = R1 + R2
    instr_mem[2] = 16'h2312;
    // SUB R4 = R3 - R1
    instr_mem[3] = 16'h3431;
    // NOP
    instr_mem[4] = 16'h0000;

    // Fill rest with NOPs
    for (r = 5; r < DEPTH; r = r + 1) begin
      instr_mem[r] = 16'h0000;
    end
  end

  // === Pipeline stages ===

  // IF Stage
  always @(posedge clk) begin
    if (reset) begin
      PC <= 0;
      IF_instr <= 0;
    end else begin
      IF_instr <= instr_mem[PC];
      PC <= PC + 1;
    end
  end

  // ID Stage
  always @(posedge clk) begin
    if (reset) begin
      ID_op  <= 0; ID_rd <= 0; ID_rs <= 0; ID_rt <= 0; ID_imm <= 0;
    end else begin
      ID_op  <= IF_instr[15:12];
      ID_rd  <= IF_instr[11:8];
      ID_rs  <= IF_instr[7:4];
      ID_rt  <= IF_instr[3:0];
      ID_imm <= IF_instr[7:0];
    end
  end

  // EX Stage
  always @(posedge clk) begin
    if (reset) begin
      EX_op <= 0; EX_rd <= 0; EX_rs <= 0; EX_rt <= 0; EX_imm <= 0;
    end else begin
      EX_op <= ID_op;
      EX_rd <= ID_rd;
      EX_rs <= ID_rs;
      EX_rt <= ID_rt;
      EX_imm <= ID_imm;

      case (ID_op)
        4'b0000: ; // NOP
        4'b0001: begin // LOAD
          regfile[ID_rd] <= {24'd0, ID_imm};
          $display("EXEC: LOAD R%0d <- %d", ID_rd, ID_imm);
        end
        4'b0010: begin // ADD
          regfile[ID_rd] <= regfile[ID_rs] + regfile[ID_rt];
          $display("EXEC: ADD R%0d <- R%0d + R%0d", ID_rd, ID_rs, ID_rt);
        end
        4'b0011: begin // SUB
          regfile[ID_rd] <= regfile[ID_rs] - regfile[ID_rt];
          $display("EXEC: SUB R%0d <- R%0d - R%0d", ID_rd, ID_rs, ID_rt);
        end
      endcase
    end
  end

  // WB Stage
  always @(posedge clk) begin
    if (reset) begin
      WB_op <= 0; WB_rd <= 0; WB_val <= 0;
    end else begin
      WB_op <= EX_op;
      WB_rd <= EX_rd;
      WB_val <= regfile[EX_rd];
    end
  end

  // === Debug outputs for testbench ===
  wire [WIDTH-1:0] dbg_r1 = regfile[1];
  wire [WIDTH-1:0] dbg_r2 = regfile[2];
  wire [WIDTH-1:0] dbg_r3 = regfile[3];
  wire [WIDTH-1:0] dbg_r4 = regfile[4];
  wire [WIDTH-1:0] dbg_pc = PC;
  wire [15:0]      dbg_instr = IF_instr;

endmodule
