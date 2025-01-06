class arithmetic_seq extends instruction_seq;
  `uvm_object_utils (arithmetic_seq)

  function new(string name = "arithmetic_seq");
    super.new(name);
  endfunction

  constraint opcode_c {opcode inside {51,19};}
  constraint funct3_c {funct3 == 0;}
  constraint funct7_c {if (opcode == 51) funct7 inside {7'b0,7'b0100000};
                       else funct7 == 0;}

  task body;
    ok = this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[19:15] = rs1;
    req.instr[11:7]  = rd;  
    if (opcode == 51)  // add - sub
      begin
        req.instr[31:25] = funct7;
        req.instr[24:20] = rs2;
      end
    else               // addi
      req.instr[31:20] = imm;    

    super.body;
  endtask
endclass

///////////////////////////////////////////////////////////////////////////////

class logic_seq extends instruction_seq;
  `uvm_object_utils (logic_seq)

  function new(string name = "logic_seq");
    super.new(name);
  endfunction

  constraint opcode_c {opcode inside {51,19};}
  constraint funct3_c {funct3 inside {3'b110,3'b111};}
  constraint funct7_c {funct7 == 7'b0;}

  task body;
    ok = this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[19:15] = rs1;
    req.instr[11:7]  = rd;  
    if (opcode == 51)  // and - or
      begin
        req.instr[31:25] = funct7;
        req.instr[24:20] = rs2;
      end
    else               //  andi - ori
      req.instr[31:20] = imm;    

    super.body;
  endtask
endclass

///////////////////////////////////////////////////////////////////////////////

class res_seq extends instruction_seq ;
  `uvm_object_utils (res_seq);

  constraint reset_c  {reset == 1;} 
  constraint add_c    {opcode == 7'd51;
                       funct3 == 3'b0;
                       funct7 == 7'b0;}

  function new(string name = "res_seq");
    super.new(name);
  endfunction

  task body;
    ok = this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[31:0]   = 32'd19; // NO OP (addi x0, x0, 0)

    super.body;
  endtask

endclass

/////////////////////////////////////////////////////////////////////


class max_pc_seq extends instruction_seq ;
  `uvm_object_utils (max_pc_seq);

  function new(string name = "max_pc_seq");
    super.new(name);
  endfunction

  task body;
    req = seq_item::type_id::create("req");

    //jal x1, 'hFFFF_FFF8 
    req.instr = 32'hFF9FF0EF;
    req.reset = 0;
    super.body;

    //any addi instruction - PC max (FFFF_FFFC)
    req.instr = 32'h00500193;
    req.reset = 0;
    super.body;

    //any addi instruction - PC = 0 (wrap around 0)
    req.instr = 32'h00500193;
    req.reset = 0;
    super.body;
  endtask

endclass

/////////////////////////////////////////////////////////////////////

class full_rand_seq extends instruction_seq;
  `uvm_object_utils(full_rand_seq)

  // Random instruction type
  rand ins_name instr_name;

  constraint valid_instr {instr_name != UNKNOWN;}

  // Instruction sequence objects
  add_seq  add_seq_h;
  sub_seq  sub_seq_h;
  and_seq  and_seq_h;
  or_seq   or_seq_h;
  addi_seq addi_seq_h;
  andi_seq andi_seq_h;
  ori_seq  ori_seq_h;
  lw_seq   lw_seq_h;
  jalr_seq jalr_seq_h;
  beq_seq  beq_seq_h;
  bne_seq  bne_seq_h;
  sw_seq   sw_seq_h;
  jal_seq  jal_seq_h;

  function new(string name = "full_rand_seq");
    super.new(name);
  endfunction

  // Create all sequence objects
  function void create_sequences();
    add_seq_h  = add_seq::type_id::create("add_seq_h");
    sub_seq_h  = sub_seq::type_id::create("sub_seq_h");
    and_seq_h  = and_seq::type_id::create("and_seq_h");
    or_seq_h   = or_seq::type_id::create("or_seq_h");
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
    andi_seq_h = andi_seq::type_id::create("andi_seq_h");
    ori_seq_h  = ori_seq::type_id::create("ori_seq_h");
    lw_seq_h   = lw_seq::type_id::create("lw_seq_h");
    jalr_seq_h = jalr_seq::type_id::create("jalr_seq_h");
    beq_seq_h  = beq_seq::type_id::create("beq_seq_h");
    bne_seq_h  = bne_seq::type_id::create("bne_seq_h");
    sw_seq_h   = sw_seq::type_id::create("sw_seq_h");
    jal_seq_h  = jal_seq::type_id::create("jal_seq_h");
  endfunction

  task body;
    //req = seq_item::type_id::create("req");
    // Create sequences
    create_sequences();

    // Randomize instruction type
    ok = this.randomize();

    // Execute the randomly selected instruction sequence
    case (instr_name)
      ADD:  `uvm_do(add_seq_h)
      SUB:  `uvm_do(sub_seq_h)
      AND:  `uvm_do(and_seq_h)
      OR:   `uvm_do(or_seq_h)
      ADDI: `uvm_do(addi_seq_h)
      ANDI: `uvm_do(andi_seq_h)
      ORI:  `uvm_do(ori_seq_h)
      LW:   `uvm_do(lw_seq_h)
      JALR: `uvm_do(jalr_seq_h)
      BEQ:  `uvm_do(beq_seq_h)
      BNE:  `uvm_do(bne_seq_h)
      SW:   `uvm_do(sw_seq_h)
      JAL:  `uvm_do(jal_seq_h)
    endcase
  endtask

endclass


















