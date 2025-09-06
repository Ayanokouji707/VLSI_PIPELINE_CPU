`timescale 1ns/1ps
module PipelineCPU_tb;

  reg clk;
  reg reset;

  // Instantiate DUT
  PipelineCPU uut (
    .clk(clk),
    .reset(reset)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period
  end

  // Stimulus
  initial begin
    $display("Starting Pipeline CPU Simulation...");
    reset = 1;
    #10;
    reset = 0;

    // Run for some time
    #200;
    $display("Simulation completed.");
    $finish;
  end

  // Monitor values
  always @(posedge clk) begin
    $display("TIME=%0t | PC=%0d | Instr=%h | R1=%0d R2=%0d R3=%0d R4=%0d",
             $time, uut.dbg_pc, uut.dbg_instr,
             uut.dbg_r1, uut.dbg_r2, uut.dbg_r3, uut.dbg_r4);
  end

endmodule
