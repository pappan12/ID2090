#!/usr/bin/bash

# INFO: Extract the date and title of the APOD images whose YYYY is divisible by the DD and MM respectively. 
# Store the results in answer_1a.csv and answer_1b.csv respectively.
# usage: ./question_1.sh

# Clearing the files and writing the headers
echo "Date, Title" >answer_1a.csv
echo "Date, Title" >answer_1b.csv

# Curl the page and store it in a variable
text=$(curl https://apod.nasa.gov/apod/archivepixFull.html)

# Using grep regex to extract the portion of lines with 'ap' followed by 6 digits and '.html">[title]'
matched_lines=$(echo "$text" | grep -oP '(?<=<a href=")ap[0-9]{6}\.html">[^<]+')

# Process each matched line
echo "$matched_lines" | while IFS= read -r line; do

    # Extract the date and title using bash slicing
    date=${line:2:6}
    title=${line:15}

    # Extract the year, month, and day using bash slicing

    year=${date:0:2}
    month=${date:2:2}
    day=${date:4:2}

    # If year > 94, prepend 19, else prepend 20
    if [ ${year#0} -gt 94 ]; then
        year="19$year"
    else
        year="20$year"
    fi

    #echo "$day/$month/$year, $title"
    
    # If YYYY is divisible by DD, append to answer_1a.csv
    if (( $year % ${day#0} == 0 )); then
        echo "$day/$month/$year, $title" >> answer_1a.csv
    fi

    # If YYYY is divisible by MM, append to answer_1b.csv
    if (( $year % ${month#0} == 0 )); then
        echo "$day/$month/$year, $title" >> answer_1b.csv
    fi
done