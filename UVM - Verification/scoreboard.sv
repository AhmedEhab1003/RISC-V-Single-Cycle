import risc_tb_pkg::*;
class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)
  `uvm_analysis_imp_decl(_mon)

  uvm_analysis_imp_mon #(seq_item, scoreboard) mon_item_export;   // mon -> sb
  uvm_blocking_get_port #(seq_item) ref_item_port;                // ref -> sb

  seq_item               dut_item;
  seq_item               expected_item;

  logic [31:0]           mem_val;

  seq_item               dut_q[$];  

  ral_model              ral_model_h;
  uvm_status_e           status;

  string                 ins;


  function new (string name = "scoreboard", uvm_component parent = null);
    super.new (name, parent);
    mon_item_export = new("mon_item_export",this);
    ref_item_port = new("ref_item_port",this);
  endfunction


  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(ral_model)::get(null, "", "ral_model_h", ral_model_h ))
      `uvm_error(get_type_name(), "RAL model not found" );
  endfunction


  function void write_mon(seq_item t);
    seq_item temp = seq_item::type_id::create("temp");
    temp.copy(t);   // avoid overwriting due to monitor/scoreboard delay difference
    dut_q.push_back(temp);
  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin

      if (dut_q.size > 0) begin
        dut_item = dut_q.pop_front;
        ref_item_port.get(expected_item);
        #10;     // clock cycle  
        compare_items(dut_item, expected_item);
      end
      else  #1ns; // Small delay to avoid busy-waiting
    end
  endtask



  task compare_items(seq_item dut_item, seq_item expected_item);
    ins = dut_item.inst_name.name;
    ral_model_h.regs[dut_item.rd].read(status, dut_item.rd_value, UVM_BACKDOOR);
    
    case(dut_item.inst_name)

      SW: 
        begin
          ral_model_h.dmem.read(status, expected_item.DataAdr[9:2], mem_val, UVM_BACKDOOR);
          compare_32b(mem_val, expected_item.WriteData, ins);
          compare_32b(dut_item.PC, expected_item.PC, ins);
          compare_1b(dut_item.MemWrite, expected_item.MemWrite, ins);
        end

      LW: 
        begin
          compare_32b(dut_item.ReadData, expected_item.rd_value, ins);
          compare_32b(dut_item.rd_value, expected_item.rd_value, ins);
          // expected value = value in memory
          // actual value = value in rd 
          compare_32b(dut_item.PC, expected_item.PC, ins);
          compare_1b(dut_item.MemWrite, expected_item.MemWrite, ins);
        end

      BEQ,BNE:     //PC will be verified in the next instruction
        begin
          compare_32b(dut_item.PC, expected_item.PC, ins);
          compare_1b(dut_item.MemWrite, expected_item.MemWrite, ins);
        end

      JAL,JALR:   //PC will be verified in the next instruction
        begin
          compare_32b(dut_item.rd_value, expected_item.rd_value, ins);
          compare_32b(dut_item.PC, expected_item.PC, ins);
          compare_1b(dut_item.MemWrite, expected_item.MemWrite, ins);
        end

      default:  //ADD,SUB,AND,OR,ANDI,ORI,ADDI
        begin
          compare_32b(dut_item.rd_value, expected_item.rd_value, ins);
          compare_32b(dut_item.PC, expected_item.PC, ins);
          compare_1b(dut_item.MemWrite, expected_item.MemWrite, ins);
        end
    endcase
  endtask


  function void compare_32b(logic[31:0] var1,var2, string ins);
    if (var1 !== var2) begin
     `uvm_error("COMPARE",$sformatf("%s: Comparison Mismatch",ins));
      $display ("actual = %0h  , expected = %0h", var1, var2);
    end else begin
      // `uvm_info("COMPARE", $sformatf("%s: Comparison Match", ins), UVM_LOW);
    end
  endfunction

  function void compare_1b(logic var1,var2, string ins);
    if (var1 !== var2) begin
      `uvm_error("COMPARE",$sformatf("%s: Comparison Mismatch",ins));
    end else begin
      //  `uvm_info("COMPARE", $sformatf("%s: Comparison Match", ins), UVM_LOW);
    end
  endfunction

endclass