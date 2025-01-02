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

class test1 extends base_test;   // debugging only , to be removed
  `uvm_component_utils(test1)

  addi_seq    addi_seq_h;
  addi_seq2   addi_seq_2h;
  jal_seq    jal_seq_h;
  sw_seq      sw_seq_h;
  lw_seq      lw_seq_h;

  function new(string name = "test1",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
    addi_seq_2h = addi_seq2::type_id::create("addi_seq_2h");
    jal_seq_h = jal_seq::type_id::create("jal_seq_h");
    sw_seq_h = sw_seq::type_id::create("sw_seq_h");
    lw_seq_h = lw_seq::type_id::create("lw_seq_h");
  endfunction : build_phase


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    addi_seq_h.start(env_h.agent_h.sequencer_h);
    addi_seq_2h.start(env_h.agent_h.sequencer_h);
    // jal_seq_h.start(env_h.agent_h.sequencer_h);
    sw_seq_h.start(env_h.agent_h.sequencer_h);
    lw_seq_h.start(env_h.agent_h.sequencer_h);
    #300;
    phase.drop_objection(this);

  endtask : run_phase

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
    repeat (1000) begin
      addi_seq_h.start(env_h.agent_h.sequencer_h);
    end
    #100;
    phase.drop_objection(this);
  endtask

endclass
/////////////////////////////////////////////////////////////////////////

class and_test extends base_test;   // to be removed
  `uvm_component_utils(and_test)

  addi_seq  addi_seq_h;
  add_seq   and_seq_h;

  function new(string name = "and_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
    and_seq_h = add_seq::type_id::create("and_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (100) begin
      addi_seq_h.start(env_h.agent_h.sequencer_h);
    end
    repeat (100) begin
      and_seq_h.start(env_h.agent_h.sequencer_h);
    end
    #100;
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