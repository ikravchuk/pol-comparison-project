#!/bin/bash

while IFS= read -r -d $'\0' file; do
	#
	sed -i 's/ftp:/https:/g' $file
	DIRNAME=$(echo "$file" | cut -d "/" -f 2)
	mkdir -p "species/${DIRNAME}/nseq" "species/${DIRNAME}/pseq"
	
	awk 'BEGIN{FS=OFS="/";filesuffix="cds_from_genomic.fna.gz"}{ftpdir=$0;asm=$10;file=asm"_"filesuffix;print ftpdir,file}' $file > species/${DIRNAME}/nseq_links 
       cat species/${DIRNAME}/nseq_links | parallel -j 20 --verbose --progress "cd species/${DIRNAME}/nseq && curl -O -f {}"	
	
       awk 'BEGIN{FS=OFS="/";filesuffix="protein.faa.gz"}{ftpdir=$0;asm=$10;file=asm"_"filesuffix;print ftpdir,file}' $file > species/${DIRNAME}/pseq_links 
       cat species/${DIRNAME}/pseq_links | parallel -j 20 --verbose --progress "cd species/${DIRNAME}/pseq && curl -O -f {}"	

done < <(find species/*/*paths -type f -print0)
