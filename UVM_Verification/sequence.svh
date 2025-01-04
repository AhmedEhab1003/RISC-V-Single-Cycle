import uvm_pkg::*;
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
  constraint funct7_c {if (opcode == 51) funct7 == 7'b0;}

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
