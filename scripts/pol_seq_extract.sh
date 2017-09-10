#!/bin/bash

while IFS= read -r -d $'\0' file; do
	#
	DIRNAME=$(echo "$file" | cut -d "/" -f 1)
	
	zcat ${DIRNAME}/nseq/* | awk '/DNA polymerase I]/' RS='>' > ${DIRNAME}/n_pols.fna
	

done < <(find */*paths -type f -print0)
