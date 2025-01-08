#!/bin/bash

# Set variables
compile_cmd="vcs -sverilog -ntb_opts uvm-1.2 -f files.f -cm line+fsm+tgl+branch+cond -timescale=1ns/1ps +vcs+flush+all -full64 +vc -q +v2k -fsdb -debug_access+all -l vcs_out.log"
sim_exe="./simv"
log_file="run_all_tests.log"
unified_log="unified_tests.log"
summary_file="summary.log"
test_list="Test_Cases/test_list.f"
coverage_dir="Coverage_Report"
vdb_files=() # Array to store .vdb directories for merging

# Clean previous logs and output files
echo "Cleaning previous logs and coverage data..."
rm -f $log_file $unified_log $summary_file *.log *.fsdb simv
rm -rf *.vdb $coverage_dir MERGE_COV

# Compile the design
echo "Compiling design..."
$compile_cmd
if [ $? -ne 0 ]; then
    echo "Compilation failed! Check vcs_out.log for details."
    exit 1
fi
echo "Compilation successful!"

# Run each test and generate a separate coverage database
if [ ! -f "$test_list" ]; then
    echo "Test list file '$test_list' not found!"
    exit 1
fi

echo "Running tests..."
test_count=0
while read -r test_name; do
    if [[ -z "$test_name" || "$test_name" == \#* ]]; then
        continue # Skip empty lines or comments
    fi

    echo "Running test: $test_name"
    test_vdb="${test_name}.vdb"
    vdb_files+=("-dir $test_vdb") # Add to list of VDB directories

    # Run the test and save its log
    $sim_exe simv.log +UVM_TESTNAME="$test_name" +covoverwrite -cm_dir $test_vdb > "${test_name}.log"
    if [ $? -ne 0 ]; then
        echo "Test $test_name failed! Check ${test_name}.log for details." | tee -a $log_file
    fi

    # Increment test count
    ((test_count++))
done < "$test_list"

# Merge all coverage databases
echo "Merging coverage data from all tests..."
urg "${vdb_files[@]}" -format both -dbname MERGE_COV -report $coverage_dir
if [ $? -ne 0 ]; then
    echo "Coverage merge failed! Check for issues with the VDB directories."
    exit 1
fi

# Generate a summary of UVM messages
echo "Generating test summary..."
echo "                        ==== TEST SUMMARY ====" >> $summary_file
echo "" >> $summary_file  # Add an empty line
echo "Total number of tests run: $test_count" >> $summary_file
echo "" >> $summary_file
printf "%-20s %-13s %-13s %-13s %-13s\n" "Test Name" "UVM_FATAL" "UVM_ERROR" "UVM_WARNING" "UVM_INFO" >> $summary_file
echo "======================================================================" >> $summary_file
for log in *_test.log; do
    test_name=$(basename "$log" .log)
    # Extract counts from the "UVM Report Summary" section
    fatal_count=$(awk '/--- UVM Report Summary ---/{flag=1} /Report counts by severity/{flag=1;next} /---/{flag=0} flag' "$log" | grep "UVM_FATAL" | awk '{print $NF}')
    error_count=$(awk '/--- UVM Report Summary ---/{flag=1} /Report counts by severity/{flag=1;next} /---/{flag=0} flag' "$log" | grep "UVM_ERROR" | awk '{print $NF}')
    warning_count=$(awk '/--- UVM Report Summary ---/{flag=1} /Report counts by severity/{flag=1;next} /---/{flag=0} flag' "$log" | grep "UVM_WARNING" | awk '{print $NF}')
    info_count=$(awk '/--- UVM Report Summary ---/{flag=1} /Report counts by severity/{flag=1;next} /---/{flag=0} flag' "$log" | grep "UVM_INFO" | awk '{print $NF}')
    
    # Default to 0 if counts are not found
    fatal_count=${fatal_count:-0}
    error_count=${error_count:-0}
    warning_count=${warning_count:-0}
    info_count=${info_count:-0}
    
    printf "%-20s    %-13d %-13d %-13d %-13d\n" "$test_name" "$fatal_count" "$error_count" "$warning_count" "$info_count" >> $summary_file
done

# Clean up unnecessary log files
echo "Cleaning up test log files..."
rm -rf *.vdb *.daidir csrc ucli* vc_hdrs.h
find . -name "*.log" ! -name "$summary_file" -delete

echo ""
echo "Coverage merge successful"
echo "Coverage Report available in $coverage_dir"
echo "Testbench summary saved in $summary_file"

