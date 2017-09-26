#!/bin/bash

# Script has 2 behaviors:

# 1. When script gets 2 argunments, they are interpreted as name of speices
#  first argument - name of genus
#  second argument - second word in the name of spieces
#
# USAGE: bash names.sh [argument1] [argument2]
# Example: bash names.sh Bacillus subtilis
# Result: - directory 'species' will be generated (if needed)
#	  - inside 'species' directory '[argument1]_[argument2]' will be generated (e.g. species/Bacilius_subtilis) with file (e.g. Bacillius_subtilis_names) (can include different strains)

# 2. When script gets only 1 argument, it is interpeted as name of genus
#  names of all spieces from this genus are aplied to this script
#
# USAGE: bash names.sh [argument1]
# Example: bash names.sh Bacillus
# Result: - generates directory 'genera' (if needed) with [argument1]_names (e.g. Bacillus_names) file (list of species)
#	  - inside 'species' directory generates directories for all species from genus with file (e.g. Bacillius_subtilis_names)

genus=$1
species=$2

function species_gen {
	
	genus=$1
	species=$2
	name="${genus}_${species}"
	echo
	echo "Creating '${name}_names' file in species/$name/"
	mkdir -p species/$name
	grep "${genus} ${species}" assembly_summary.txt | cut -f 8 | sort -u > "species/$name/${name}_names"
	echo -e "\033[0;32mDone\033[0m"
	echo

}




# if no arguments

if [ $# = 0 ]; then
	echo
	echo -e "\033[0;31mYou need to specify genus or full spiecies name as arguments for this script.\033[0m"
	echo
	echo -e "\033[0;31mExample 1: bash names.sh Bacillus subtilis\033[0m"
	echo -e "\033[0;31mExample 2: bash names.sh Bacillus\033[0m"
	echo
	exit
fi


# FIRST BEHAVIOR (full species name, two words = two arguments)

if [ $species ]; then			
	species_gen $genus $species
	exit
fi

# SECOND BEHAVIOR (genus name only, one argument)

echo
echo "Creating '${genus}_names' file in genera/$genus/"
mkdir -p genera/$genus
grep "${genus}" assembly_summary.txt | cut -f 8 | sort -u | grep -v "\[" > "genera/$genus/${genus}_names"
echo -e "\033[0;32mDone\033[0m"
echo
echo "Creating '_names' files for all species of $genus"
echo

# reading names of species from genus_name file
# applying species_gen to all names
file="genera/$genus/${genus}_names"
names="genera/$genus/${genus}_without_strains_names"
grep $genus $file | cut -f1,2 -d " " | sort -u > $names
while IFS= read -r line; do species_gen $line; done < $names

exit

