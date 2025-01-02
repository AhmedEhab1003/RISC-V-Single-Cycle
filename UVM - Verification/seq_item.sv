import risc_tb_pkg::*;

class seq_item extends uvm_sequence_item;

  rand logic   reset     ; 
  logic [31:0] PC        ;
  logic [31:0] WriteData ;
  logic [31:0] DataAdr   ;
  logic [31:0] ReadData  ;
  logic        MemWrite  ;

  rand logic [31:0] instr;
  rand ins_type inst_type;
  rand ins_name inst_name;

  logic [4:0]  rd;             // destination register
  logic [31:0] rd_value;       // destination register value

  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(reset, UVM_NOCOMPARE)
  `uvm_field_int(WriteData, UVM_DEFAULT)
  `uvm_field_int(DataAdr, UVM_DEFAULT)
  `uvm_field_int(ReadData, UVM_DEFAULT)
  `uvm_field_int(MemWrite, UVM_DEFAULT)  
  `uvm_field_int(PC, UVM_DEFAULT)
  `uvm_field_int(instr, UVM_DEFAULT)
  `uvm_field_enum(ins_type, inst_type, UVM_DEFAULT) 
  `uvm_field_enum(ins_name, inst_name, UVM_DEFAULT) 
  `uvm_field_int(rd, UVM_DEFAULT)
  `uvm_field_int(rd_value, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "seq_item");
    super.new (name);
  endfunction


  function void get_instruction_info();
    get_name_type (instr, inst_name, inst_type, rd);
  endfunction


  function void copy(uvm_object rhs);
    seq_item rhs_item;
    // Ensure the right type of object is being copied
    if (!$cast(rhs_item, rhs)) begin
      `uvm_fatal("COPY_FAIL", "Invalid object type in copy")
      return;
    end
    // Copy all fields
    this.reset       = rhs_item.reset;
    this.PC          = rhs_item.PC;
    this.WriteData   = rhs_item.WriteData;
    this.DataAdr     = rhs_item.DataAdr;
    this.ReadData    = rhs_item.ReadData;
    this.MemWrite    = rhs_item.MemWrite;
    this.instr       = rhs_item.instr;
    this.inst_type   = rhs_item.inst_type;
    this.inst_name   = rhs_item.inst_name;
    this.rd          = rhs_item.rd;
    this.rd_value    = rhs_item.rd_value;
  endfunction

endclass