#!/usr/bin/bash

# This script performs sql join operation on two csv files
# usage: ./question_4.sh [-ILRF] <file_1.csv> <file_2.csv> > out.csv

# Check if the number of arguments is correct
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 [-ILRF] <file_1.csv> <file_2.csv>"
    exit 1
fi

# The first argument is the flag for the type of join
flag=$1
file1=$2
file2=$3

# Find the common column between the two files
common_column=$(awk -F', *' '
    FNR==1 {
        if (NR == FNR) {
            for (i = 1; i <= NF; i++) {
                a[$i] = 1
            }
        } 
        else {
            for (i = 1; i <= NF; i++) {
                if ($i in a) {
                    print $i
                }
            }
        }
    }
' "$file1" "$file2")

# Making a map of the first file
declare -A file1_map
header=1
while IFS=', ' read -r col1 col2 || [[ -n "$col1" ]]; do
    if [ $header -eq 1 ]; then
        echo -n "$col1, $col2, "
        if [ "$col1" == "$common_column" ]; then
            key_index_1=1
        else
            key_index_1=2
        fi
        header=0
    else
        if [ $key_index_1 -eq 1 ]; then
            file1_map["$col1"]="$col2"
        else
            file1_map["$col2"]="$col1"
        fi
    fi
done <"$file1"

# Making a map of the second file
declare -A file2_map
header=1
while IFS=', ' read -r col1 col2 || [[ -n "$col1" ]]; do
    if [ $header -eq 1 ]; then
        if [ "$col1" == "$common_column" ]; then
            key_index_2=1
            echo "$col2"
        else
            key_index_2=2
            echo "$col1"
        fi
        header=0
    else
        if [ $key_index_2 -eq 1 ]; then
            file2_map["$col1"]="$col2"
        else
            file2_map["$col2"]="$col1"
        fi
    fi
done <"$file2"

# Perform the join operation

if [ $flag != "-L" ] && [ $flag != "-R" ] && [ $flag != "-F" ] && [ $flag != "-I" ]; then
    echo "Invalid flag"
    exit 1
fi

(
    for key in "${!file1_map[@]}"; do
        if [ ! -z "${file2_map[$key]}" ]; then
            if [ $key_index_1 -eq 1 ]; then
                echo "$key, ${file1_map[$key]}, ${file2_map[$key]}"
            else
                echo "${file1_map[$key]}, $key, ${file2_map[$key]}"
            fi
        fi
    done

    if [ "$flag" == "-L" ]; then
        for key in "${!file1_map[@]}"; do
            if [ -z "${file2_map[$key]}" ]; then
                if [ $key_index_1 -eq 1 ]; then
                    echo "$key, ${file1_map[$key]}, NULL"
                else
                    echo "${file1_map[$key]}, $key, NULL"
                fi
            fi
        done
    elif [ "$flag" == "-R" ]; then
        for key in "${!file2_map[@]}"; do
            if [ -z "${file1_map[$key]}" ]; then
                if [ $key_index_1 -eq 1 ]; then
                    echo "$key, NULL, ${file2_map[$key]}"
                else
                    echo "NULL, $key, ${file2_map[$key]}"
                fi
            fi
        done
    elif [ "$flag" == "-F" ]; then
        for key in "${!file1_map[@]}"; do
            if [ -z "${file2_map[$key]}" ]; then
                if [ $key_index_1 -eq 1 ]; then
                    echo "$key, ${file1_map[$key]}, NULL"
                else
                    echo "${file1_map[$key]}, $key, NULL"
                fi
            fi
        done
        for key in "${!file2_map[@]}"; do
            if [ -z "${file1_map[$key]}" ]; then
                if [ $key_index_1 -eq 1 ]; then
                    echo "$key, NULL, ${file2_map[$key]}"
                else
                    echo "NULL, $key, ${file2_map[$key]}"
                fi
            fi
        done
    fi
) | sort -t, -k$key_index_1 # Sort the output
