class ref_model extends uvm_subscriber #(seq_item);
  `uvm_object_utils(ref_model)

  uvm_analysis_imp #(seq_item, ref_model) mon_item_export;

  uvm_blocking_get_imp #(seq_item, ref_model) expected_port;

  logic [31:0] ins_q[$];

  seq_item       expected_item;
  ral_model      ral_model_h;
  uvm_status_e   status;

  logic [4:0]   rs1 , rs2 ;
  logic [31:0]  rs1_value;
  logic [31:0]  rs2_value;
  logic [11:0]  I_imm;
  logic [11:0]  S_imm;
  logic [11:0]  B_imm;
  logic [19:0]  J_imm;

  bit   [31:0]  pc_current;
  bit   [31:0]  pc_next;

  logic [7:0] phy_mem_add;


  function new (string name = "ref_model", uvm_component parent = null);    
    super.new(name, parent);
    mon_item_export = new("mon_item_export",this);
    expected_port = new("expected_port",this);
    if (!uvm_config_db #(ral_model)::get(null, "", "ral_model_h", ral_model_h ))
      `uvm_error(get_type_name(), "RAL model not found" );
  endfunction


  function void write (seq_item t);
    ins_q.push_back(t.instr);
  endfunction

  task get(output seq_item t);
    expected_item = seq_item::type_id::create("expected_item");
    expected_item.instr = ins_q.pop_front;
    get_expected();
    t = expected_item;
  endtask


  task get_expected();

    expected_item.get_instruction_info;

    case (expected_item.inst_name)

      ADD: 
        begin
          rs1   = expected_item.instr[19:15];
          rs2   = expected_item.instr[24:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          ral_model_h.regs[rs2].read(status, rs2_value, UVM_BACKDOOR);
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = rs1_value + rs2_value;
          get_expected_pc();
          expected_item.MemWrite = 0;
        end

      SUB: 
        begin
          rs1   = expected_item.instr[19:15];
          rs2   = expected_item.instr[24:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          ral_model_h.regs[rs2].read(status, rs2_value, UVM_BACKDOOR);
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = rs1_value - rs2_value;
          get_expected_pc();
          expected_item.MemWrite = 0;
        end

      AND: 
        begin
          rs1   = expected_item.instr[19:15];
          rs2   = expected_item.instr[24:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          ral_model_h.regs[rs2].read(status, rs2_value, UVM_BACKDOOR);
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = rs1_value & rs2_value;
          get_expected_pc();
          expected_item.MemWrite = 0;
        end

      OR: 
        begin
          rs1   = expected_item.instr[19:15];
          rs2   = expected_item.instr[24:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          ral_model_h.regs[rs2].read(status, rs2_value, UVM_BACKDOOR);
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = rs1_value | rs2_value;
          get_expected_pc();
          expected_item.MemWrite = 0;
        end

      ADDI: 
        begin
          rs1   = expected_item.instr[19:15];
          I_imm = expected_item.instr[31:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = rs1_value + sign_extend(I_imm);
          get_expected_pc();
          expected_item.MemWrite = 0;
        end

      ANDI: 
        begin
          rs1   = expected_item.instr[19:15];
          I_imm = expected_item.instr[31:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = rs1_value & sign_extend(I_imm);
          get_expected_pc();
          expected_item.MemWrite = 0;
        end

      ORI: 
        begin
          rs1   = expected_item.instr[19:15];
          I_imm = expected_item.instr[31:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = rs1_value | sign_extend(I_imm);
          get_expected_pc();
          expected_item.MemWrite = 0;
        end

      LW: 
        begin
          rs1   = expected_item.instr[19:15];
          I_imm = expected_item.instr[31:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          expected_item.DataAdr = rs1_value + sign_extend(I_imm);
          phy_mem_add = expected_item.DataAdr [9:2]; // ignore first 2 bits (9:2) in dmem
          expected_item.rd = expected_item.instr[11:7];
          get_expected_pc();
          // expected value = value in memory
          // actual value = value in rd 
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          ral_model_h.dmem.read(status, phy_mem_add, expected_item.rd_value, UVM_BACKDOOR);
          expected_item.MemWrite = 1'b0 ;
        end

      JALR: 
        begin
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = pc_current + 4;
          I_imm = expected_item.instr[31:20];
          rs1 = expected_item.instr[19:15];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          expected_item.MemWrite = 0;
          expected_item.PC = pc_current;
          pc_next = rs1_value + sign_extend(I_imm);
          pc_current = pc_next;
        end

      BEQ: 
        begin
          B_imm = {expected_item.instr[31],
                   expected_item.instr[7],
                   expected_item.instr[30:25],
                   expected_item.instr[11:8]};
          rs1 = expected_item.instr[19:15];
          rs2 = expected_item.instr[24:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          ral_model_h.regs[rs2].read(status, rs2_value, UVM_BACKDOOR);
          expected_item.PC = pc_current;
          expected_item.MemWrite = 0;
          if (rs1_value == rs2_value) begin
            pc_next = pc_current + (sign_extend(B_imm)*2);
            pc_current = pc_next;
          end
          else get_expected_pc();
        end

      BNE: 
        begin
          B_imm = {expected_item.instr[31],
                   expected_item.instr[7],
                   expected_item.instr[30:25],
                   expected_item.instr[11:8]};
          rs1 = expected_item.instr[19:15];
          rs2 = expected_item.instr[24:20];
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          ral_model_h.regs[rs2].read(status, rs2_value, UVM_BACKDOOR);
          expected_item.PC = pc_current;
          expected_item.MemWrite = 0;
          if (rs1_value != rs2_value) begin
            pc_next = pc_current + (sign_extend(B_imm)*2);
            pc_current = pc_next;
          end
          else get_expected_pc();
        end

      JAL: 
        begin
          expected_item.rd       = expected_item.instr[11:7];
          if (!expected_item.rd)  expected_item.rd_value = 0; else
          expected_item.rd_value = pc_current + 4;
          J_imm = {expected_item.instr[31],  
                   expected_item.instr[19:12],   
                   expected_item.instr[20],  
                   expected_item.instr[30:21]};
          expected_item.MemWrite = 0;
          expected_item.PC       = pc_current;
          pc_next = pc_current + (sign_extend_20b(J_imm)*2);
          pc_current = pc_next;
        end

      SW: 
        begin
          rs1   = expected_item.instr[19:15];
          rs2   = expected_item.instr[24:20];
          S_imm = {expected_item.instr[31:25],expected_item.instr[11:7]};
          ral_model_h.regs[rs1].read(status, rs1_value, UVM_BACKDOOR);
          ral_model_h.regs[rs2].read(status, rs2_value, UVM_BACKDOOR);
          expected_item.DataAdr = rs1_value + sign_extend(S_imm);
          expected_item.WriteData = rs2_value;
          expected_item.MemWrite = 1'b1 ;
          get_expected_pc();
          expected_item.MemWrite = 1;
        end

      default: 
        begin
        end

    endcase
  endtask

  function void get_expected_pc();   // to be modified
    expected_item.PC = pc_current;
    pc_next = pc_current + 4;
    pc_current = pc_next;
  endfunction

endclass
