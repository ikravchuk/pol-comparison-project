#!/bin/bash

while IFS= read -r -d $'\0' file; do
	#
	DIRNAME=$(echo "$file" | cut -d "/" -f 1)
	zcat ${DIRNAME}/nseq/* | awk '/DNA polymerase I]/' RS='>' | sed 's/lcl|/>lcl|/g'  > ${DIRNAME}/n_pols.fna
	zcat ${DIRNAME}/pseq/* | awk '/DNA polymerase I /' RS='>' | sed 's/\n\n/\n\n\>/g'  > ${DIRNAME}/p_pols.faa
	

done < <(find */*paths -type f -print0)
