#!/usr/bin/bash

# This script calculates the tfidf of words in a document
# usage: ./question_3.sh <file.csv> [word]

# Preprocessing the data
preprocessed_data=$(cat "$1" | tail -n +2 | cut -d' ' -f2- | tr -d ",." | tr [:upper:] [:lower:])
D=$(echo "$preprocessed_data" | wc -l)

# Function to calculate tfidf
tfidf() {
    card=$(
        awk -v word="$1" '
        BEGIN {
            count=0
        } 
        $0 ~ word {
            for(i=1;i<=NF;i++) if($i==word) {count++; break;}
        } 
        END{print count}
    ' <<<"$preprocessed_data"
    )

    idf=$(echo "l(($D+1)/($card+1))/l(2)" | bc -l)

    tfsum=0

    tfsum=$(awk -v word="$1" '
        BEGIN {tfsum=0}
        $0 ~ word {
            f=0;
            for(i=1;i<=NF;i++) if($i==word) f++;
            tfsum+=f/NF;
        }
        END {print tfsum}
    ' <<<"$preprocessed_data")

    tfidf=$(echo "($tfsum*$idf)/$D" | bc -l)

    printf "%.4f" $tfidf
}

# For one word
if [ "$#" -eq 2 ]; then
    echo $(tfidf "${2,,}")

# For top 5
else
    word_set=$(cat "$1" | tail -n +2 | cut -d "," -f2- | tr -d ",." | tr [:upper:] [:lower:] | tr ' ' '\n' | sort | uniq )
    for word in $word_set; do
        echo "$word, $(tfidf "$word")"
    done | sort -k2 -nr | head -n 5
fi