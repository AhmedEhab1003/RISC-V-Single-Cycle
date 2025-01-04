virtual class base_test extends uvm_test;  
  //`uvm_component_utils(base_test);
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
endclass
