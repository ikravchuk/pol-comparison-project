#!/bin/bash

while IFS= read -r -d $'\0' file; do
	#
	sed -i 's/ftp:/https:/g' $file
	DIRNAME=$(echo "$file" | cut -d "/" -f 1)
	mkdir -p "${DIRNAME}/nseq" "${DIRNAME}/pseq"
	
	awk 'BEGIN{FS=OFS="/";filesuffix="cds_from_genomic.fna.gz"}{ftpdir=$0;asm=$10;file=asm"_"filesuffix;print ftpdir,file}' $file > ${DIRNAME}/nseq_links 
       cat ${DIRNAME}/nseq_links | parallel -j 20 --verbose --progress "cd ${DIRNAME}/nseq && curl -O {}"	
	
       awk 'BEGIN{FS=OFS="/";filesuffix="protein.faa.gz"}{ftpdir=$0;asm=$10;file=asm"_"filesuffix;print ftpdir,file}' $file > ${DIRNAME}/pseq_links 
       cat ${DIRNAME}/pseq_links | parallel -j 20 --verbose --progress "cd ${DIRNAME}/pseq && curl -O {}"	

done < <(find */*paths -type f -print0)
