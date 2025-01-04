class arithmetic_test extends base_test;
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
