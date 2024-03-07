#!/usr/bin/bash

#For finding the function connecting the ASCII Code of the characters to the corresponding code, I used sagemath to DataFit the points.

#data = {
#    'A': 13130, 'B': 13464, 'C': 13802, 'D': 14144, 'E': 14490, 'F': 14840, 'G': 15194, 'H': 15552, 'I': 15914, 'J': 16280,
#    'K': 16650, 'L': 17024, 'M': 17402, 'N': 17784, 'O': 18170, 'P': 18560, 'Q': 18954, 'R': 19352, 'S': 19754, 'T': 20160,
#    'U': 20570, 'V': 20984, 'W': 21402, 'X': 21824, 'Y': 22250, 'Z': 22680, 'a': 25802, 'b': 26264, 'c': 26730, 'd': 27200,
#    'e': 27674, 'f': 28152, 'g': 28634, 'h': 29120, 'i': 29610, 'j': 30104, 'k': 30602, 'l': 31104, 'm': 31610, 'n': 32120,
#    'o': 32634, 'p': 33152, 'q': 33674, 'r': 34200, 's': 34730, 't': 35264, 'u': 35802, 'v': 36344, 'w': 36890, 'x': 37440,
#    'y': 37994, 'z': 38552
#}
#
#data_list = [(ord(key), value) for key, value in data.items()]
#
#p1=list_plot(data_list,color='green')
#p1.show()
#
#var('b, c, x')
#model(x) = b*x + c*x**2 
#sol = find_fit(data_list,model)
#show(sol)

#The function so obtained is y=2x^2+72x where x is the ASCII Code of that letter.

#Error Handling
if [ "$#" -ne 1 ]; then
    echo "Error: No URL provided. Usage: ./script.sh <url>"
    exit 1
fi

#Removing output.txt if it already exists
if [ -f output.txt ]; then
    rm output.txt
fi

#Obtain text from URL entered as an argument
text=$(curl -s $1)

#Function to decode the encoded text
decode() {
    local line=$1 #
    local dec=""
    for y in $line; do
        if [ "$y" -eq 0 ]; then #Ignore the null byte
            continue
        else
            local x=$(bc -l <<< "-18 + sqrt(324 + $y/2)") #Converts it into ASCII
            x=${x%%.*}  # Make it integer
            chr=$(printf "\\$(printf "%03o" "$x")") #Obtain ASCII Character from ASCII Code
            dec+="$chr"
        fi
    done
    echo "$dec"
}

#Read the encoded text and decode it
while IFS=' ' read -r roll en; do
    dec=$(decode "$en")
    echo "$roll,$dec" | tee -a output.txt #Output the decoded text to a file
done < <(tail -n +53 <<< "$text") #Skip the first 52 lines of text

#For future reference the encoded text file in the repository is encoded.txt