#!/bin/bash

while IFS= read -r -d $'\0' file; do
	#
	DIRNAME=$(echo "$file" | cut -d "/" -f 2)
	zcat species/${DIRNAME}/nseq/* |  bioawk -c fastx '{print ">"$name,$comment"@"$seq}' | grep "polymerase I]" | tr "@" "\n" > species/${DIRNAME}/n_pols.fna
	zcat species/${DIRNAME}/pseq/* | bioawk -c fastx '{print ">"$name,$comment"@"$seq}' | grep "polymerase I " | tr "@" "\n"  > species/${DIRNAME}/p_pols.faa
	

done < <(find species/*/*paths -type f -print0)
