import uvm_pkg::*;
class coverage extends uvm_subscriber #(seq_item);
  `uvm_object_utils(coverage)

  uvm_analysis_imp #(seq_item, coverage) mon_item_export;

  ins_name instruction;
  logic [4:0]   rs1;
  logic [4:0]   rs2;
  logic [4:0]   rd;
  logic [11:0]  I_imm;
  logic [11:0]  S_imm;
  logic [11:0]  B_imm;
  logic [19:0]  J_imm;


  covergroup instruction_cg;
    instruction_cp: coverpoint instruction {
      bins R_type[] = {ADD, SUB, AND, OR};
      bins I_type[] = {ADDI, ANDI, ORI, LW, JALR};
      bins J_type[] = {JAL};
      bins B_type[] = {BEQ, BNE};
      bins unknown = {UNKNOWN};
    }
    rs1_cp: coverpoint rs1 {
      bins all_registers[] = {[0:31]};
    }
    rs2_cp: coverpoint rs2 {
      bins all_registers[] = {[0:31]};
    }
    rd_cp: coverpoint rd {
      bins all_registers[] = {[0:31]};
    }
    cross_instruction_rs1_rs2: cross instruction_cp, rs1_cp, rs2_cp;
    cross_instruction_rd : cross instruction_cp, rd_cp;
  endgroup

  function new (string name = "coverage", uvm_component parent = null);    
    super.new(name, parent);
    mon_item_export = new("mon_item_export",this);
    instruction_cg = new();
    //     if (!uvm_config_db #(ral_model)::get(null, "", "ral_model_h", ral_model_h ))
    //       `uvm_error(get_type_name(), "RAL model not found" );
  endfunction

  //////////////////////////////////////////////////////////////////////////
  function void write (seq_item t);
    seq_item cov_item = seq_item::type_id::create("cov_item");
    cov_item.copy(t);
    ins_decode (cov_item);
    //`uvm_info(get_name(), $sformatf("cov item:\n %s",cov_item.sprint), UVM_LOW)
    instruction_cg.sample();
  endfunction

  //////////////////////////////////////////////////////////////////////////

  function void ins_decode (seq_item cov_item);

    instruction = cov_item.inst_name;

    case (cov_item.inst_type)
      R: 
        begin
          rd  = cov_item.instr[11:7];
          rs1 = cov_item.instr[19:15];
          rs2 = cov_item.instr[24:20];
        end

      I: 
        begin 
          rd    = cov_item.instr[11:7];
          rs1   = cov_item.instr[19:15];
          I_imm = cov_item.instr[31:20];
        end

      S: 
        begin
          rs1   = cov_item.instr[19:15];
          rs2   = cov_item.instr[24:20];
          S_imm = {cov_item.instr[31:25],
                   cov_item.instr[11:7]};
        end

      B: 
        begin
          rs1   = cov_item.instr[19:15];
          rs2   = cov_item.instr[24:20];
          B_imm = {cov_item.instr[31],
                   cov_item.instr[7],
                   cov_item.instr[30:25],
                   cov_item.instr[11:8]};
        end

      J:
        begin
          rd    = cov_item.instr[11:7];
          J_imm = {cov_item.instr[31],
                   cov_item.instr[19:12],
                   cov_item.instr[20],
                   cov_item.instr[30:21]};
        end
    endcase
  endfunction

  function void cov_sample (seq_item cov_item);

  endfunction

endclass
