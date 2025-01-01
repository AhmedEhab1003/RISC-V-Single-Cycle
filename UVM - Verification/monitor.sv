class monitor extends uvm_monitor;

  `uvm_component_utils (monitor)        // factory registry

  virtual riscv_if riscv_bus;
  agent_cnfg cfg_h;

  uvm_analysis_port #(seq_item) item_collected_port;

  function new (string name = "monitor", uvm_component parent = null);
    super.new(name,parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db  #(agent_cnfg) ::get(this,"" , "configuration", cfg_h ))
      `uvm_fatal(get_type_name(), "configuration not found" )
      this.riscv_bus = cfg_h.riscv_bus;
  endfunction

  task run_phase (uvm_phase phase);

    seq_item mon_pkt = seq_item::type_id::create("mon_pkt");
    forever begin
      wait (cfg_h.sync_start.triggered);
      #1;  // avoid racing
      collect_packet(mon_pkt);
      mon_pkt.get_instruction_info();
      //`uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", mon_pkt.sprint()), UVM_LOW)
      item_collected_port.write(mon_pkt);
    end
  endtask


  task collect_packet(seq_item mon_pkt);
    // inputs
    mon_pkt.reset = riscv_bus.reset;
    mon_pkt.instr = riscv_bus.Instr;

    // outputs
    mon_pkt.PC         = riscv_bus.PC;
    mon_pkt.WriteData  = riscv_bus.WriteData;
    mon_pkt.DataAdr    = riscv_bus.DataAdr;
    mon_pkt.ReadData   = riscv_bus.ReadData;
    mon_pkt.MemWrite   = riscv_bus.MemWrite;

    -> cfg_h.sync_end;
  endtask

endclass