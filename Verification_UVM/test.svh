class base_test extends uvm_test;  // to be virtual
  `uvm_component_utils(base_test);
  env   env_h;
  agent_cnfg cfg_h;

  virtual riscv_if riscv_bus;

  function new (string name = "base_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    env_h = env::type_id::create("env_h", this);
    cfg_h = agent_cnfg::type_id::create("cfg_h");

    if(!uvm_config_db #(virtual riscv_if)::get(this, "", "riscv_if", riscv_bus))
      `uvm_fatal(get_type_name(), "Failed to retrieve Interface");

    cfg_h.riscv_bus = this.riscv_bus;

    uvm_config_db #(agent_cnfg)::set(this, "*" , "configuration" , cfg_h);
  endfunction  


  //   virtual function void end_of_elaboration();
  //     //print's the topology
  //     print();
  //   endfunction

endclass

/////////////////////////////////////////////////////////////////////////


class addi_test extends base_test;
  `uvm_component_utils(addi_test)

  addi_seq  addi_seq_h;

  function new(string name = "addi_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (1000) addi_seq_h.start(env_h.agent_h.sequencer_h);
    #100;
    phase.drop_objection(this);
  endtask

endclass
/////////////////////////////////////////////////////////////////////////

class logic_test extends base_test;   
  `uvm_component_utils(logic_test)

  logic_seq logic_seq_h;

  function new(string name = "logic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    logic_seq_h = logic_seq::type_id::create("logic_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (100) logic_seq_h.start(env_h.agent_h.sequencer_h);
    #100;
   //$stop;
    phase.drop_objection(this);
  endtask

endclass

/////////////////////////////////////////////////////////////////////////

class mem_acc_test extends base_test;
  `uvm_component_utils(mem_acc_test)

  addi_seq  addi_seq_h;
  sw_seq    sw_seq_h;
  lw_seq    lw_seq_h;

  function new(string name = "mem_acc_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
    sw_seq_h = sw_seq::type_id::create("sw_seq_h");
    lw_seq_h = lw_seq::type_id::create("lw_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (100) addi_seq_h.start(env_h.agent_h.sequencer_h);

    repeat (100) sw_seq_h.start(env_h.agent_h.sequencer_h);

    repeat (100) lw_seq_h.start(env_h.agent_h.sequencer_h);

    #100;
    phase.drop_objection(this);
  endtask

endclass
/////////////////////////////////////////////////////////////////////////


class arithmetic_test extends base_test;   // verify add addi sub
  `uvm_component_utils(arithmetic_test)

  arithmetic_seq   arithmetic_seq_h;

  function new(string name = "arithmetic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    arithmetic_seq_h = arithmetic_seq::type_id::create("arithmetic_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (1000) arithmetic_seq_h.start(env_h.agent_h.sequencer_h);
    #100;
    phase.drop_objection(this);
  endtask

endclass
/////////////////////////////////////////////////////////////////////////

class sub_test extends base_test;
  `uvm_component_utils(sub_test)

  addi_seq  addi_seq_h;
  sub_seq   sub_seq_h;

  function new(string name = "sub_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
    sub_seq_h = sub_seq::type_id::create("sub_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (100) addi_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (1000) sub_seq_h.start(env_h.agent_h.sequencer_h);

    #100;
    phase.drop_objection(this);
  endtask

endclass


/////////////////////////////////////////////////////////////////////////

class jump_test extends base_test;
  `uvm_component_utils(jump_test)

  addi_seq   addi_seq_h;
  jal_seq    jal_seq_h;
  jalr_seq   jalr_seq_h;

  function new(string name = "jump_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
    jalr_seq_h = jalr_seq::type_id::create("jalr_seq_h");
    jal_seq_h  = jal_seq::type_id::create("jal_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (100)  addi_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (1000) jal_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (1000) jalr_seq_h.start(env_h.agent_h.sequencer_h);

    #100;
    phase.drop_objection(this);
  endtask

endclass


/////////////////////////////////////////////////////////////////////////

class branch_test extends base_test;
  `uvm_component_utils(branch_test)

  addi_seq   addi_seq_h;
  beq_seq    beq_seq_h;
  bne_seq    bne_seq_h;

  function new(string name = "branch_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
    beq_seq_h  = beq_seq::type_id::create("beq_seq_h");
    bne_seq_h  = bne_seq::type_id::create("bne_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (100)  addi_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (1000) beq_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (1000) bne_seq_h.start(env_h.agent_h.sequencer_h);

    #100;
    phase.drop_objection(this);
  endtask

endclass