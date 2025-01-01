class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)


  virtual riscv_if riscv_bus;
  seq_item transaction;
  agent_cnfg cfg_h;

  function new (string name = "driver", uvm_component parent = null);
    super.new (name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db  #(agent_cnfg) ::get(this,"" , "configuration", cfg_h ))
      `uvm_fatal(get_type_name(), "configuration not found" )
      this.riscv_bus = cfg_h.riscv_bus;
  endfunction



  task run_phase (uvm_phase phase);

    forever begin
      seq_item_port.get_next_item (transaction);
      transaction.get_instruction_info;

      // `uvm_info(get_name(), $sformatf("Sending instruction:\n %s",
      //                                 transaction.sprint), UVM_LOW)


      send_to_dut(transaction);

      seq_item_port.item_done();
    end
  endtask:run_phase


  task send_to_dut(seq_item item);

    @(posedge riscv_bus.clk);
    -> cfg_h.sync_start;
    riscv_bus.reset <= item.reset;
    riscv_bus.Instr <= item.instr;
   // wait (cfg_h.sync_end.triggered); // wait for monitor
  endtask



endclass
