import uvm_pkg::*;
`include "uvm_macros.svh"

import risc_tb_pkg::*;

module test;
  
  string blk_hdl_path = "test.DUT";
  string mem_hdl_path = "dmem.RAM";
  string reg_hdl_path = "RISC_V.dp.rf.register[%0d]";
  string PC_hdl_path  = "RISC_V.dp.pcreg.d";

  import uvm_pkg::*;

  bit clk;
  bit reset;

  always #5 clk = ~clk;

  riscv_if  riscv_bus (clk);


  top DUT (.clk(riscv_bus.clk),
           .reset         (riscv_bus.reset),
           .Instr         (riscv_bus.Instr),
           .ReadData      (riscv_bus.ReadData),
           .PC            (riscv_bus.PC),
           .WriteData     (riscv_bus.WriteData),
           .DataAdr       (riscv_bus.DataAdr),
           .MemWrite      (riscv_bus.MemWrite));


  initial begin
    uvm_config_db #(virtual riscv_if)::set(null,"uvm_test_top", "riscv_if", riscv_bus);
    uvm_config_db #(string)::set(null,"*", "blk_hdl_path", blk_hdl_path);
    uvm_config_db #(string)::set(null,"*", "mem_hdl_path", mem_hdl_path);
    uvm_config_db #(string)::set(null,"*", "reg_hdl_path", reg_hdl_path);
    uvm_config_db #(string)::set(null,"*", "PC_hdl_path" , PC_hdl_path);
    
    run_test("mem_acc_test");
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars();
  end

endmodule



