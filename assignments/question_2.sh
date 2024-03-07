#!/usr/bin/bash

# Check if the correct number of arguments were provided for script
if [ "$#" -ne 2 ]; then
    echo "Error: Incorrect number of arguments. Usage: ./question_2.sh <file1> <file2>"
    exit 1
fi

# Read initial.txt and obtain the values of a, b, c, f1 and f2
IFS=',' read -r a b c f1 f2 < "$1"

# Read the number of testcases
read t < "$2"

# Check if the correct number of testcases were provided
if [ $(grep -c . "$2") -ne $(($t+1)) ]; then
    echo "Error: Incorrect number of testcases"
    exit 1
fi

# Function to calculate the nth neofibonacci number
neofbn() {
    local n=$(($1-2)) # Subtract 2 because the first two numbers are already given
    local npp=$f1
    local np=$f2
    local nt=
    for ((i=0; i<n; i++)); do
        # Calculate the next number with precision of 4 decimal places
        nt=$(echo "scale=4; ($b*$np+$c*$npp)/$a" | BC_LINE_LENGTH=0 bc) 

        npp=$np
        np=$nt			
    done
    echo "$nt"
}

# Print the neofibonacci number for each testcase
tail -n +2 "$2" | { # Skip the first line
    for ((i=0; i<t; i++)); do
        read n
        
		# Check if either of the first two numbers are asked
        if [ $n -eq 1 ]; then
            echo "$f1"
        elif [ $n -eq 2 ]; then		
            echo "$f2"

        # Normal case
        else
            ans=$(neofbn "$n")
            echo "$ans"
        fi
    done
}