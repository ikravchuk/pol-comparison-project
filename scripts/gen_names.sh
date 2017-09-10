#!/bin/bash

. $(dirname "$0")/config.sh # defaults for project

# Script generates list of spiecies from specified genus
# It takes the name of GENUS that comes from first argument of script
# Then it forms list of spiecies that has data in 'assembly_summary.txt'
# from NCBI : 
#
# BASIC USAGE: bash gen_script.sh [argument1]
# Example: bash gen_script.sh Bacillus
# Result: - generates directory 'Bacillus' (if needed) with Bacillus_names file (list of spicies) 

GENUS=$1
MESSAGE="Creating '${GENUS}_names' file with names of spicies from genus $GENUS..."

# SPEC_SP - second word in the name of special spiecies that treated separatly.
# SPEC_GEN - special genus (first name of special spicies),
# while list generation data about SPEC_SP should be excluded from SPEC_GEN.
#
# Default values of SPEC_SP and SPEC_GEN come from config.sh
# BUT can be changed when script has second argument:
#
# USAGE: bash gen_script.sh [argument1] [argument2]
# Example: bash gen_script.sh Bacillus subtilis
# Result: - second argument changes default SPEC_SP
#	  - first argument (when argument2 added to script) changes SPEC_GEN
#	  - directory generated (e.g. Bacilius_subtilis) with file (e.g. Bacillius_subtilis_names) (can include different strains)
#	  - directory for SPEC_GEN generated with file SPEC_GEN_names without special spiecies (e.g. without Bacillius subtilis)


# defaults

SPEC_SP=$(echo $DEFAULT_SP | cut -d ' ' -f 2) # second word from DEFAULT_SP
SPEC_GEN=$(echo $DEFAULT_SP | cut -d ' ' -f 1) # first word from DEFAULT_SP

# if first argument exists
if [ $1 ]; then			
	# if second argument exists
	if [ $2 ]; then
		SPEC_SP=$2	# changes to value from second argument (second word from spieces name)
		SPEC_GEN=$1	# changes to value from first argument (genus name)
		
		# generate names for special spicies
		echo
		echo "Creating '${SPEC_GEN}_${SPEC_SP}_names' file with names in ${SPEC_GEN}_${SPEC_SP}..."
		mkdir -p ${SPEC_GEN}_${SPEC_SP}
		grep "${SPEC_GEN} ${SPEC_SP}" assembly_summary.txt | cut -f 8 | sort -u > "${SPEC_GEN}_${SPEC_SP}/${SPEC_GEN}_${SPEC_SP}_names"
		echo -e "\033[0;32mDone\033[0m"
		
		# generate names for genus without special spieces
		echo
		echo $MESSAGE
		mkdir -p $SPEC_GEN
		grep $SPEC_GEN assembly_summary.txt | cut -f 8 | sort -u | grep -v "$SPEC_SP" > "$SPEC_GEN/${SPEC_GEN}_names"
		echo -e "\033[0;32mDone\033[0m"
		echo

	# if second argument does not exist, but value of first argument equal to value of SPEC_GEN
	elif [ "$SPEC_GEN" == "$GENUS"  ]; then 
		# generate names for special genus without special spieces
		echo
		echo $MESSAGE
		mkdir -p $SPEC_GEN
		grep $SPEC_GEN assembly_summary.txt | cut -f 8 | sort -u | grep -v "$SPEC_SP" > "$SPEC_GEN/${SPEC_GEN}_names"
		echo -e "\033[0;32mDone\033[0m"
		echo
	
	# default behavior
	else	
		echo
		echo $MESSAGE
		mkdir -p $GENUS
		grep $GENUS assembly_summary.txt | cut -f 8 | sort -u > "$GENUS/${GENUS}_names"
		echo -e "\033[0;32mDone\033[0m"
		echo 
	fi
# if no arguments
else
	echo -e "\033[0;31mYou need to specify genus name as argument for this script.\033[0m"
fi
