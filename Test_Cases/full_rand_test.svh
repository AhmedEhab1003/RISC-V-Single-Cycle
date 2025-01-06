class full_rand_test extends base_test;
  `uvm_component_utils(full_rand_test)
  
  full_rand_seq   full_rand_seq_h;

  function new(string name = "full_rand_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    full_rand_seq_h = full_rand_seq::type_id::create("full_rand_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    res_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (5000)  full_rand_seq_h.start(env_h.agent_h.sequencer_h);

    #100;
    phase.drop_objection(this);
  endtask

endclass
