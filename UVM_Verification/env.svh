class env extends uvm_env;
  `uvm_component_utils(env)

  scoreboard          scoreboard_h;
  agent               agent_h;
  coverage            coverage_h;
  ral_model           ral_model_h;
  ref_model           ref_model_h;

  int data; uvm_status_e status;


  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ral_model_h   = ral_model::type_id::create("ral_model_h"); 
    ral_model_h.build();
    ral_model_h.lock_model();
    //ral_model_h.reset();
    //ral_model_h.print();

    uvm_config_db#(ral_model)::set(null, "*", "ral_model_h", ral_model_h);

    agent_h       = agent::type_id::create("agent_h",this);
    scoreboard_h  = scoreboard::type_id::create("scoreboard_h",this);
    coverage_h    = coverage::type_id::create("coverage_h",this);
    ref_model_h   = ref_model::type_id::create("ref_model_h",this); 
  endfunction

  function void connect_phase(uvm_phase phase);
    agent_h.monitor_h.item_collected_port.connect(scoreboard_h.mon_item_export);
    agent_h.monitor_h.item_collected_port.connect(coverage_h .mon_item_export);
    agent_h.monitor_h.item_collected_port.connect(ref_model_h .mon_item_export);
    scoreboard_h.ref_item_port.connect(ref_model_h.expected_port);
  endfunction

endclass: env
