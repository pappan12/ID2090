#!/usr/bin/awk -f

# INFO:To process given vehicle data and clean it and idenitify fakes
# usage: ./question_2.sh final_dataset.txt > out.csv

BEGIN {
    #Creating map for the letters to replace them with their (27-i)th complement
    t["A"] = "Z"
    t["B"] = "Y"
    t["C"] = "X"
    t["D"] = "W"
    t["E"] = "V"
    t["F"] = "U"
    t["G"] = "T"
    t["H"] = "S"
    t["I"] = "R"
    t["J"] = "Q"
    t["K"] = "P"
    t["L"] = "O"
    t["M"] = "N"
    t["N"] = "M"
    t["O"] = "L"
    t["P"] = "K"
    t["Q"] = "J"
    t["R"] = "I"
    t["S"] = "H"
    t["T"] = "G"
    t["U"] = "F"
    t["V"] = "E"
    t["W"] = "D"
    t["X"] = "C"
    t["Y"] = "B"
    t["Z"] = "A" 
}

# Processing each line
{
    # If first line, print the header
    if (NR == 1) {
        print "Vehicle Number, SoC, Mileage(in m), Charging Time(in min), SoH, Driver Name, Flag"
    } 
    # If 6 fields, process the line ( removing useless rows )
    else if (NF == 6) { 
        dn=$6 #Storing the driver's name
        new_dn = ""
        for (i=1; i<=length(dn); i++) {
            new_dn = new_dn t[substr(dn, i, 1)] #Appending the complement of the current letter to new_dn
        }
        dn = new_dn #Replacing the driver's name with the new string
        soc=$2 #Storing soc and soh so as to interchange them for vehicle AG
        soh=$5
        if (substr($1,1,2)=="AG")  {
            soc=$5
            soh=$2
        } 
        flag=""
        if (soc == 0 && $3 != 0) {
            flag=", Fake" #If soc is 0 and mileage is not 0, then the entry is misreported and flagged fake
        }
        print $1 ", " soc ", " $3 ", " $4 ", " soh ", " dn flag #Printing the processed line
    }
}