#!/bin/bash

while IFS= read -r -d $'\0' file; do
	#
	DIRNAME=$(echo "$file" | cut -d "/" -f 1)
	zcat ${DIRNAME}/nseq/* |  bioawk -c fastx '{print ">"$name,$comment"@"$seq}' | grep "polymerase I]" | tr "@" "\n" > ${DIRNAME}/n_pols.fna
	zcat ${DIRNAME}/pseq/* | bioawk -c fastx '{print ">"$name,$comment"@"$seq}' | grep "polymerase I " | tr "@" "\n"  > ${DIRNAME}/p_pols.faa
	

done < <(find */*paths -type f -print0)
