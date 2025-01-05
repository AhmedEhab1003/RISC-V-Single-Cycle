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
    start_item(req);
    finish_item(req);
    
    //any addi instruction - PC max (FFFF_FFFC)
    req.instr = 32'h00500193;
    req.reset = 0;
    start_item(req);
    finish_item(req);
    
    //any addi instruction - PC = 0 (wrap around 0)
    req.instr = 32'h00500193;
    req.reset = 0;
    start_item(req);
    finish_item(req);
  endtask

endclass



















