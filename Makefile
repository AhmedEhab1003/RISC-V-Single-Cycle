
#-------------------------------------------------------------------------------------------------------
run  : clean compile logic_test
#-------------------------------------------------------------------------------------------------------
compile	:
	vcs -sverilog -ntb_opts uvm-1.2 -f files.f -cm line+fsm+tgl+branch+cond -timescale=1ns/1ps +vcs+flush+all -full64  +vc -q +v2k  -fsdb -debug_all -l vcs_out.log
#-------------------------------------------------------------------------------------------------------
verdi  :
	verdi -f files.f -ssf -sv tb.fsdb &
#-------------------------------------------------------------------------------------------------------
coverage  :
	urg -dir simv.vdb  &
#-------------------------------------------------------------------------------------------------------
cov_verdi  :
	verdi -cov -covdir simv.vdb &
#-------------------------------------------------------------------------------------------------------
clean  :
	 rm  -rf  *~  core  csrc  simv*  vc_hdrs.h  ucli.key  urg* *.log  novas.* *.fsdb* verdiLog  64* DVEfiles *.simv.daidir simv.vdb *.vcd *.vdb *.daidir *_sim
#-------------------------------------------------------------------------------------------------------
coverage_html  :
	urg -dir simv.vdb &
#-------------------------------------------------------------------------------------------------------
logic_test :
	./logic_sim logic_sim.log +UVM_TESTNAME=logic_test 
#-------------------------------------------------------------------------------------------------------
addi_test  :
	./simv simv.log +UVM_TESTNAME=addi_test
#-------------------------------------------------------------------------------------------------------
mem_acc_test  :
	./simv simv.log +UVM_TESTNAME=mem_acc_test
#-------------------------------------------------------------------------------------------------------
sub_test  :
	./sub_sim sub_sim.log +UVM_TESTNAME=sub_test
#-------------------------------------------------------------------------------------------------------
arithmetic_test  :
	./simv simv.log +UVM_TESTNAME=arithmetic_test
#-------------------------------------------------------------------------------------------------------
jump_test  :
	./simv simv.log +UVM_TESTNAME=jump_test
#-------------------------------------------------------------------------------------------------------
branch_test  :
	./simv simv.log +UVM_TESTNAME=branch_test
#-------------------------------------------------------------------------------------------------------
all_tests  : addi_test sub_test logic_test mem_acc_test arithmetic_test jump_test branch_test
#-------------------------------------------------------------------------------------------------------
regression  : clean compile all_tests
#-------------------------------------------------------------------------------------------------------
compile_1	:
	vcs -sverilog -ntb_opts uvm-1.2 -f files.f -cm line+fsm+tgl+branch+cond -timescale=1ns/1ps +vcs+flush+all -full64  +vc -o sub_sim -q +v2k  -fsdb -debug_all -l vcs_out.log
#-------------------------------------------------------------------------------------------------------
compile_2	:
	vcs -sverilog -ntb_opts uvm-1.2 -f files.f -cm line+fsm+tgl+branch+cond -timescale=1ns/1ps +vcs+flush+all -full64  +vc -o logic_sim -q +v2k  -fsdb -debug_all -l vcs_out.log
#-------------------------------------------------------------------------------------------------------
coverage_1  :
	urg -dir sub_sim.vdb &
#-------------------------------------------------------------------------------------------------------
coverage_2  :
	urg -dir logic_sim.vdb &
#-------------------------------------------------------------------------------------------------------
two_tests  : sub_test logic_test
#-------------------------------------------------------------------------------------------------------
merge  :
	urg -dir sub_sim.vdb -dir logic_sim.vdb -dir result.vdb -dbname MERGE_COV
#-------------------------------------------------------------------------------------------------------
now  : clean compile_1 compile_2 two_tests coverage_1 coverage_2 merge














