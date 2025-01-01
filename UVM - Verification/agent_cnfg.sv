class agent_cnfg extends uvm_object;

  uvm_active_passive_enum active = UVM_ACTIVE;

  event sync_start;
  event sync_end;

  virtual riscv_if riscv_bus;        

  function new(string name = "agent_cnfg");
    super.new(name);
  endfunction

  	
    // Register to FACTORY
  `uvm_object_utils_begin(agent_cnfg)
  `uvm_field_enum(uvm_active_passive_enum, active, UVM_DEFAULT) 
  `uvm_object_utils_end


endclass