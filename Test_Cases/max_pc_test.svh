class max_pc_test extends base_test;
  `uvm_component_utils(max_pc_test)

  max_pc_seq  max_pc_seq_h;

  function new(string name = "max_pc_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    max_pc_seq_h = max_pc_seq::type_id::create("max_pc_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    res_seq_h.start(env_h.agent_h.sequencer_h);
    max_pc_seq_h.start(env_h.agent_h.sequencer_h);

    #100;
    phase.drop_objection(this);
  endtask

endclass
