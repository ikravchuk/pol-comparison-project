#!/bin/bash

# cat bac_n_pols.fna| bioawk -c fastx '{print $name,$comment"@"$seq}'| split -d -l 10 - bac-pol


#!/bin/bash

while IFS= read -r -d $'\0' file; do
	  # stuff with "$file" here
	  NAME=$(echo "$file" | cut -d "/" -f 2)
	  FILENAME="species/$NAME/${NAME}"
	 # check number of sequences in $file
	 # if only 1 sequence -> no alignment, sequence is reference sequence, and conservative interval == sequence length

	 
	 # if file contains more than 10 sequence ->
	  # if split into files with 5 sequenecs, check number of sequences align, make ref, join (align refs), check , repeat until 1 ref


	  grep -f $file assembly_summary.txt | cut -f 20 | sort -u > $FILENAME
 done < <(find species/*/*pols -type f -print0)
