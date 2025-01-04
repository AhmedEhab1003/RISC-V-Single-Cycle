class addi_test extends base_test;
  `uvm_component_utils(addi_test)

  addi_seq  addi_seq_h;

  function new(string name = "addi_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    addi_seq_h = addi_seq::type_id::create("addi_seq_h");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    res_seq_h.start(env_h.agent_h.sequencer_h);
    repeat (1000) addi_seq_h.start(env_h.agent_h.sequencer_h);
    #100;
    phase.drop_objection(this);
  endtask

endclass
