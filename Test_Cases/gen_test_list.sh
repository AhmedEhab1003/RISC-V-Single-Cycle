#!/bin/bash

# File to store test names
TESTS_FILE="test_list.f"

# Counter for added tests
test_count=0

# Create or clear the tests file
> "$TESTS_FILE"

# Process each .svh file in the current directory
for file in *.svh; do
    # Skip if no .svh files found
    [[ -e "$file" ]] || continue
    
    # Skip base_test.svh as it's virtual
    if [[ "$file" == "base_test.svh" ]]; then
        continue
    fi

    # Extract class name from the file
    # Look for "class <name> extends" pattern and get the class name
    class_name=$(grep -o "class [a-zA-Z_][a-zA-Z0-9_]* extends" "$file" | awk '{print $2}')
    
    # Check if the class is virtual (contains "virtual" keyword before class definition)
    is_virtual=$(grep -B 1 "class $class_name extends" "$file" | grep -c "virtual")
    
    # If class is not virtual, add it to the tests file
    if [ "$is_virtual" -eq 0 ] && [ ! -z "$class_name" ]; then
        echo "$class_name" >> "$TESTS_FILE"
        echo "Added test: $class_name"
        ((test_count++))
    fi
done

# Check if any tests were added
if [ "$test_count" -eq 0 ]; then
    echo "No non-virtual tests found"
else
    echo -e "\nTotal number of tests added: $test_count"
fi
