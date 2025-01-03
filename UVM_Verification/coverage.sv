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

  function new (string name = "coverage", uvm_component parent = null);    
    super.new(name, parent);
    mon_item_export = new("mon_item_export",this);
    if (!uvm_config_db #(ral_model)::get(null, "", "ral_model_h", ral_model_h ))
      `uvm_error(get_type_name(), "RAL model not found" );
  endfunction
/////////////////////////////////////////////////////////////////////////
  
  covergroup g1;

  endgroup
  
//////////////////////////////////////////////////////////////////////////
  function void write (seq_item t);
    seq_item cov_item = seq_item::type_id::create("cov_item");
    cov_item.copy(t);
    cov_sample(cov_item);
  endfunction

//////////////////////////////////////////////////////////////////////////

  function void ins_decode (seq_item cov_item);
    case (cov_item.ins_type)
      R: 
        begin
          rd  = instruction[11:7];
          rs1 = instruction[19:15];
          rs2 = instruction[24:20];
        end

      I: 
        begin 
          rd    = instruction[11:7];
          rs1   = instruction[19:15];
          I_imm = instruction[31:20];
        end

      S: 
        begin
          rs1   = instruction[19:15];
          rs2   = instruction[24:20];
          S_imm = {instruction[31:25],
                   instruction[11:7]};
        end

      B: 
        begin
          rs1   = instruction[19:15];
          rs2   = instruction[24:20];
          B_imm = {instruction[31],
                   instruction[7],
                   instruction[30:25],
                   instruction[11:8]};
        end

      J:
        begin
          rd    = instruction[11:7];
          J_imm = {instruction[31],
                   instruction[19:12],
                   instruction[20],
                   instruction[30:21]};
        end
    endcase
  endfunction
  
  function void cov_sample (seq_item cov_item);
    
  endfunction

endclass