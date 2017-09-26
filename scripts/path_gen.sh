#!/bin/bash

while IFS= read -r -d $'\0' file; do
	  # stuff with "$file" here
	  NAME=$(echo "$file" | cut -d "/" -f 2)
	  FILENAME="species/$NAME/${NAME}_paths"
	  grep -f $file assembly_summary.txt | cut -f 20 | sort -u > $FILENAME
 done < <(find species/*/*names -type f -print0)
