import uvm_pkg::*;
class agent extends uvm_agent;
  `uvm_component_utils (agent)       

  agent_cnfg    cfg_h;                     
  sequencer		sequencer_h;            
  driver		driver_h;
  monitor		monitor_h;


  function new (string name = "agent", uvm_component parent = null);    
    super.new(name,parent);    
  endfunction


  function void build_phase (uvm_phase phase);    
    super.build_phase (phase);


    if (!uvm_config_db  #(agent_cnfg) ::get(this,"" , "configuration", cfg_h ))
      `uvm_fatal(get_type_name(), "agent configuration not found" )

      this.cfg_h = cfg_h;   

    if(cfg_h.active == UVM_ACTIVE)
      begin   
        driver_h = driver::type_id::create("driver_h", this); 
        sequencer_h = sequencer::type_id::create("sequencer_h", this); 
        //`uvm_info(get_name(), " Agent is Active ", UVM_LOW);
        //cfg_h.print();
      end 

    monitor_h = monitor::type_id::create ("monitor_h",this);
  endfunction



  function void connect_phase (uvm_phase phase);
    super.connect_phase (phase);
    if(cfg_h.active == UVM_ACTIVE)   
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  endfunction

endclass
