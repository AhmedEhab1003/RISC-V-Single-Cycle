class logic_test extends base_test;   
  `uvm_component_utils(logic_test)

  logic_seq logic_seq_h;

  function new(string name = "logic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    logic_seq_h = logic_seq::type_id::create("logic_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    res_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (100) logic_seq_h.start(env_h.agent_h.sequencer_h);
    #100;
    phase.drop_objection(this);
  endtask

endclass
