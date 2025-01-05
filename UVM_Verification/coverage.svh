class coverage extends uvm_subscriber #(seq_item);
  `uvm_object_utils(coverage)

  uvm_analysis_imp #(seq_item, coverage) mon_item_export;

  ins_name instruction;
  logic         reset;
  logic [31:0]  PC;
  logic [4:0]   rs1;
  logic [4:0]   rs2;
  logic [4:0]   rd;
  logic [11:0]  I_imm;
  logic [11:0]  S_imm;
  logic [11:0]  B_imm;
  logic [19:0]  J_imm;

  logic [31:0] WriteData ;
  logic [31:0] DataAdr   ;
  logic [31:0] ReadData  ;
  logic        MemWrite  ;


  covergroup instruction_cg;
    instruction_cp: coverpoint instruction {
      bins R_type[] = {ADD, SUB, AND, OR};
      bins I_type[] = {ADDI, ANDI, ORI, LW, JALR};
      bins J_type[] = {JAL};
      bins S_type[] = {SW};
      bins B_type[] = {BEQ, BNE};
      illegal_bins unknown = {UNKNOWN};
    }

    instruction_transition_cp: coverpoint instruction {
      bins r_after_r = ([ADD:OR] => [ADD:OR]);
      bins r_after_i = ([ADDI:ORI] => [ADD:OR]);
      bins i_after_r = ([ADD:OR] => [ADDI:ORI]);
      bins branch_after_compute = ([ADD:ORI] => BEQ,BNE);
      bins load_after_compute = ([ADD:ORI] => LW);
      bins store_after_load = (LW => SW);
      bins load_after_store = (SW => LW);
      bins jump_sequences = (JAL,JALR => [ADD:SW]);
    }

    rs1_cp:    coverpoint rs1   {bins all_registers[] = {[0:31]};}

    rs2_cp:    coverpoint rs2   {bins all_registers[] = {[0:31]};}

    rd_cp:     coverpoint rd    {bins all_registers[] = {[0:31]};}

    PC_max_cp: coverpoint PC    {bins pc_boundary[]   = {32'h0 ,32'hffff_fffc};
                                 bins wrap_arround    = (32'hffff_fffc => 32'h0);
                                }


    // Immediate value coverage
    I_imm_cp: coverpoint I_imm {
      bins zero = {0};
      bins pos[16] = {[1:32'h7FF]};
      bins neg[16] = {[32'h800:32'hFFF]};
    }

    // Cross coverage for all regs as rs1 with R-type instructions
    R_instr_src1_cross: cross instruction_cp, rs1_cp {
      bins r_type_src1 = binsof(instruction_cp.R_type) && binsof(rs1_cp);
    }
    // Cross coverage for all regs as rs2 with R-type instructions
    R_instr_src2_cross: cross instruction_cp, rs2_cp {
      bins r_type_src2 = binsof(instruction_cp.R_type) && binsof(rs2_cp);
    }

    // Cross coverage for all regs as rd with R-type instructions
    R_instr_dst_cross: cross instruction_cp, rd_cp {
      bins r_type_rd = binsof(instruction_cp.R_type) && binsof(rd_cp);
    }

    // Cross coverage for all regs as rs1 with I-type instructions
    I_instr_src1_cross: cross instruction_cp, rs1_cp {
      bins i_type_src1 = binsof(instruction_cp.I_type) && binsof(rs1_cp);
    }

    // Cross coverage for all regs as rd with I-type instructions
    I_instr_rd_cross: cross instruction_cp, rd_cp {
      bins i_type_rd = binsof(instruction_cp.I_type) && binsof(rd_cp);
    }

    // Cross coverage for i_imm with I-type instructions
    I_instr_imm_cross: cross instruction_cp, I_imm {
      bins i_type_imm = binsof(instruction_cp.I_type) && binsof(I_imm);
    }

    // // Cross coverage for all regs as rs1 with B-type instructions
    // B_instr_src1_cross: cross instruction_cp, rs1_cp{
    //   bins b_type_src1 = binsof(instruction_cp.B_type) && binsof(rs1_cp);
    // }

    // // Cross coverage for all regs as rs2 with B-type instructions
    // B_instr_src2_cross: cross instruction_cp, rs2_cp{
    //   bins b_type_src2 = binsof(instruction_cp.B_type) && binsof(rs2_cp);
    // }
  endgroup

  covergroup memory_operations_cg;
    // Cover memory write/read operations
    MemWrite_cp: coverpoint MemWrite {
      bins mem_write = {1};
      bins mem_read  = {0};
    }

    // Cover data address, Total addressable words: 256 
    DataAdr_cp: coverpoint DataAdr[9:2] {
      bins first_location = {8'h00};                             // first word
      bins last_location = {8'hFF};                              // Last word (address 255)
      bins lower_quarter[8] = {[8'h01:8'h3F]};                   // Lower quarter of memory
      bins middle_half[16] = {[8'h40:8'hBF]};                    // Middle of memory
      bins upper_quarter[8] = {[8'hC0:8'hFE]};                   // Upper quarter of memory
      bins sequential_access = ([8'h00:8'hFF] => [8'h00:8'hFF]); // Sequential access patterns
    }

    // Cover write data patterns
    WriteData_cp: coverpoint WriteData {
      bins zero = {32'h0};
      bins all_ones = {32'hFFFF_FFFF};
      bins alternating[] = {32'hAAAA_AAAA, 32'h5555_5555};
      bins default_values = default;
    }

    // Cover read data patterns
    ReadData_cp: coverpoint ReadData {
      bins zero = {32'h0};
      bins all_ones = {32'hFFFF_FFFF};
      bins alternating[] = {32'hAAAA_AAAA, 32'h5555_5555};
      bins default_values = default;
    }

    // Cross coverage between write operations and addresses
    write_addr_cross: cross MemWrite_cp, DataAdr_cp {
      bins write_addresses = binsof(MemWrite_cp.mem_write) && binsof(DataAdr_cp);
    }

    // Cross coverage between read operations and addresses
    read_addr_cross: cross MemWrite_cp, DataAdr_cp {
      bins write_addresses = binsof(MemWrite_cp.mem_read) && binsof(DataAdr_cp);
    }

    // Cross coverage for write data and addresses during write operations
    write_data_addr_cross: cross MemWrite_cp, WriteData_cp, DataAdr_cp {
      bins write_data_at_addr = binsof(MemWrite_cp.mem_write) && 
      binsof(WriteData_cp) && 
      binsof(DataAdr_cp);
    }

    // Cross coverage for read data and addresses during read operations
    read_data_addr_cross: cross MemWrite_cp, ReadData_cp, DataAdr_cp {
      bins read_data_at_addr = binsof(MemWrite_cp.mem_read) && 
      binsof(ReadData_cp) && 
      binsof(DataAdr_cp);
    }
  endgroup

  covergroup reset_cg;
    reset_active: coverpoint reset {
      bins active   = {1};
      bins inactive = {0};}
  endgroup


  function new (string name = "coverage", uvm_component parent = null);    
    super.new(name, parent);
    mon_item_export = new("mon_item_export",this);
    instruction_cg = new();
    memory_operations_cg = new();
    reset_cg = new();
  endfunction

  //////////////////////////////////////////////////////////////////////////
  function void write (seq_item t);
    seq_item cov_item = seq_item::type_id::create("cov_item");
    cov_item.copy(t);
    ins_decode (cov_item);
    coverage_sample();
  endfunction

  //////////////////////////////////////////////////////////////////////////

  function void ins_decode (seq_item cov_item);

    instruction = cov_item.inst_name;
    reset       = cov_item.reset;
    PC          = cov_item.PC;
    WriteData   = cov_item.WriteData;
    DataAdr     = cov_item.DataAdr;
    ReadData    = cov_item.ReadData;
    MemWrite    = cov_item.MemWrite;

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

  function void coverage_sample ();
    instruction_cg.sample();
    memory_operations_cg.sample();
    reset_cg.sample();
  endfunction

endclass
