#!/bin/bash

while IFS= read -r -d $'\0' file; do
	#
	#mafft --clustalout $file > "${file}.align"	
	clustalo -i $file -o "${file}.clustal" --outfmt=clu --resno --force
done < <(find */{n,p}_pols.f{n,a}a -type f -print0)
