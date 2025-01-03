class instruction_seq extends uvm_sequence #(seq_item) ;  // to be virtual
  `uvm_object_utils (instruction_seq);

  rand bit [6:0]  opcode;
  rand bit [2:0]  funct3;
  rand bit [6:0]  funct7;
  rand bit [4:0]  rs1, rs2, rd;   // Source and destination registers
  rand bit [11:0] imm;            // I,S,B immediate
  rand bit [19:0] jmm;            // J immediate
  rand bit        reset;

  //constraint rd_c     {rd != 0;}       // don't write in x0
  constraint reset_c  {reset == 0;}    // turn off reset for now 


  function new(string name = "instruction_seq");
    super.new(name);
  endfunction

  task body;
    start_item(req);
    finish_item(req);
  endtask
endclass
//-------------------------------------------------------------------------


class add_seq extends instruction_seq ;
  `uvm_object_utils (add_seq)

  constraint add_c  {opcode == 7'd51;
                     funct3 == 3'b0;
                     funct7 == 7'b0;} 

  function new(string name = "add_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[31:25] = funct7;
    req.instr[19:15] = rs1;
    req.instr[24:20] = rs2;     
    req.instr[11:7]  = rd;      

    super.body;
  endtask

endclass

//-------------------------------------------------------------------------

class sub_seq extends instruction_seq ;
  `uvm_object_utils (sub_seq);


  constraint sub_c  {opcode == 7'd51;
                     funct3 == 3'b0;
                     funct7 == 7'b0100000;} 

  function new(string name = "sub_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[31:25] = funct7;
    req.instr[19:15] = rs1;
    req.instr[24:20] = rs2;     
    req.instr[11:7]  = rd;      

    super.body;
  endtask

endclass

//-------------------------------------------------------------------------

class and_seq extends instruction_seq ;
  `uvm_object_utils (and_seq);


  constraint and_c  {opcode == 7'd51;
                     funct3 == 3'b111;
                     funct7 == 7'b0;} 

  function new(string name = "and_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[31:25] = funct7;
    req.instr[19:15] = rs1;
    req.instr[24:20] = rs2;     
    req.instr[11:7]  = rd;      

    super.body;
  endtask
endclass

//-------------------------------------------------------------------------

class or_seq extends instruction_seq ;
  `uvm_object_utils (or_seq);

  constraint or_c  {opcode == 7'd51;
                    funct3 == 3'b110;
                    funct7 == 7'b0;} 

  function new(string name = "or_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[31:25] = funct7;
    req.instr[19:15] = rs1;
    req.instr[24:20] = rs2;     
    req.instr[11:7]  = rd;      

    super.body;
  endtask
endclass

//-------------------------------------------------------------------------

class addi_seq extends instruction_seq ;
  `uvm_object_utils (addi_seq);


  constraint addi_c  {opcode == 7'd19;
                      funct3 == 3'b0;} 

  function new(string name = "addi_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[19:15] = rs1;     
    req.instr[11:7]  = rd;      
    req.instr[31:20] = imm;    

    super.body;
  endtask
endclass

//-------------------------------------------------------------------------

class andi_seq extends instruction_seq ;
  `uvm_object_utils (andi_seq);

  constraint andi_c  {opcode == 7'd19;
                      funct3 == 3'b111;} 
  constraint imm_c   {imm inside {[0:500]};}

  function new(string name = "andi_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[19:15] = rs1;     
    req.instr[11:7]  = rd;      
    req.instr[31:20] = imm;    

    super.body;
  endtask
endclass

//-------------------------------------------------------------------------

class ori_seq extends instruction_seq ;
  `uvm_object_utils (ori_seq);

  constraint ori_c  {opcode == 7'd19;
                     funct3 == 3'b110;} 
  constraint imm_c   {imm inside {[0:500]};}

  function new(string name = "ori_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[19:15] = rs1;     
    req.instr[11:7]  = rd;      
    req.instr[31:20] = imm;    

    super.body;
  endtask
endclass

//-------------------------------------------------------------------------

class lw_seq extends instruction_seq ;
  `uvm_object_utils (lw_seq);

  constraint lw_c    {opcode == 7'd3;
                      funct3 == 3'b010;} 
  // constraint imm_c   {imm inside {[0:500]};}

  function new(string name = "lw_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[19:15] = rs1;     
    req.instr[11:7]  = rd;      
    req.instr[31:20] = imm;    

    super.body;
  endtask
endclass

//-------------------------------------------------------------------------

class jalr_seq extends instruction_seq ;
  `uvm_object_utils (jalr_seq);

  function new(string name = "jalr_seq");
    super.new(name);
  endfunction

  task body;
    req = seq_item::type_id::create("req");
    start_item(req);

    assert(req.randomize() with {
      req.reset == 0;
      req.instr[6:0] == 103;
      req.instr[14:12] == 3'b0;
      req.instr[19:15] == 1;
    });

    finish_item(req);
  endtask
endclass

//-------------------------------------------------------------------------

class beq_seq extends instruction_seq ;
  `uvm_object_utils (beq_seq);

  function new(string name = "beq_seq");
    super.new(name);
  endfunction

  task body;
    req = seq_item::type_id::create("req");
    start_item(req);

    assert(req.randomize() with {
      req.reset == 0;
      req.instr[6:0] == 99;
      req.instr[14:12] == 3'b0;
      req.instr[19:15] == 1;
      req.instr[24:20] == 2;
    });

    finish_item(req);
  endtask
endclass

//-------------------------------------------------------------------------

class bne_seq extends instruction_seq ;
  `uvm_object_utils (bne_seq);

  function new(string name = "bne_seq");
    super.new(name);
  endfunction

  task body;
    req = seq_item::type_id::create("req");
    start_item(req);

    assert(req.randomize() with {
      req.reset == 0;
      req.instr[6:0] == 99;
      req.instr[14:12] == 3'b001;
      req.instr[19:15] == 1;
      req.instr[24:20] == 2;
    });

    finish_item(req);
  endtask
endclass

//-------------------------------------------------------------------------

class sw_seq extends instruction_seq ;
  `uvm_object_utils (sw_seq);

  constraint sw_c    {opcode == 7'd35;
                      funct3 == 3'b010;} 
 // constraint imm_c   {imm inside {[0:500]};}

  function new(string name = "sw_seq");
    super.new(name);
  endfunction

  task body;
    this.randomize();
    req = seq_item::type_id::create("req");

    req.reset = reset;
    req.instr[6:0]   = opcode; 
    req.instr[14:12] = funct3;
    req.instr[19:15] = rs1;     
    req.instr[24:20] = rs2;      
    req.instr[11:7]  = imm[4:0]; 
    req.instr[31:25] = imm[11:5];

    super.body;
  endtask
endclass

//-------------------------------------------------------------------------

class jal_seq extends instruction_seq ;
  `uvm_object_utils (jal_seq);

  function new(string name = "jal_seq");
    super.new(name);
  endfunction

  task body;
    req = seq_item::type_id::create("req");
    start_item(req);

    assert(req.randomize() with {
      req.reset == 0;
      req.instr[6:0] == 111;});

    finish_item(req);
  endtask
endclass

//-------------------------------------------------------------------------


class addi_seq2 extends instruction_seq ;
  `uvm_object_utils (addi_seq2);

  function new(string name = "addi_seq2");
    super.new(name);
  endfunction

  task body;
    req = seq_item::type_id::create("req");
    start_item(req);

    assert(req.randomize() with {
      req.reset == 0;
      req.instr[6:0]   == 19;
      req.instr[14:12] == 3'b0;
      req.instr[11:7]  == 5'd2;
      req.instr[31:20] ==  231;
    });

    finish_item(req);
  endtask
endclass


class res_seq extends instruction_seq ;
  `uvm_object_utils (res_seq);

  function new(string name = "res_seq");
    super.new(name);
  endfunction

  task body;
    req = seq_item::type_id::create("req");
    start_item(req);

    assert(req.randomize() with {
      req.reset == 1;});

    finish_item(req);
  endtask

endclass