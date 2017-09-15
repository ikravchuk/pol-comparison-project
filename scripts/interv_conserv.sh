#!/bin/bash

while IFS= read -r -d $'\0' file; do
	lines=( $(awk '/*/ {print FNR}' $file) )
	for (( i=0; i<${#lines[@]}; i++ )); do cat $file | sed -n ${lines[i]}p | tail -c +17 | head -c -4 >> ${file}.matrix; done
	
# align (after mafft) 
# cat n_pols.fna.align | sed -n '15p' | tail -c +17 | head -c -4
# 3 lines + 11 (number of fastas) + 1 = first
# first + (11 + 2) number of fastas + 2 = second
# awk '/*/ {print FNR}' n_pols.fna.align 

# clustal (after clustalo) 
# cat n_pols.fna.clustal | sed -n '15p' | tail -c +45 | head -c -4

done < <(find */*.align -type f -print0)
