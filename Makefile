

## setup			: setup all dependencies, download 
.PHONY : setup
setup :
	@echo "setup should be created ;)"


## assembly_summary.txt	: download summary for all Bacteria genomes from NCBI

assembly_summary.txt :
	@echo "-------------------------------------------------------------------"
	@echo "Getting assembly summary for all Bacteria genomes from NCBI..."
	@echo "-------------------------------------------------------------------"
	curl -O https://ftp.ncbi.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"

## acc2taxid.txt		: download list of accession ids associated with taxids

acc2taxid.txt :
	@echo "-------------------------------------------------------------------"
	@echo "Getting list of accession ids associated with taxids from NCBI..."
	@echo "-------------------------------------------------------------------"
	curl -O https://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/nucl_gb.accession2taxid.gz | gunzip -c > acc2taxid.txt 
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"



## names2taxids		: creates file with taxids for all 'name' files

.PHONY : names2taxids
names2taxids : names
	@echo "-------------------------------------------------------------------"
	@echo "Creating files with taxids for each 'names' files..."
	@echo "-------------------------------------------------------------------"
	taxonkit name2taxid < $< | cut -f 2 > taxids	
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"


## names			: create list of spieces from genus Geobacillus + other genera

.PHONY : names
names : geobac_names other_names
	@echo "-------------------------------------------------------------------"
	@echo "Creating 'names' file with names from Geobacillus and other genera..."
	@echo "-------------------------------------------------------------------"
	cat Geobacillus/Geobacillus_names genera/other_names > names	
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"


## geobac_names		: create list of spieces from genus Geobacillus in Geobacillus directory

.PHONY : geobac_names
geobac_names : Geobacillus_stearothermophilus/Geobacillus_stearothermophilus_names

Geobacillus_stearothermophilus/Geobacillus_stearothermophilus_names :  assembly_summary.txt scripts/gen_names.sh
	bash scripts/gen_names.sh Geobacillus stearothermophilus


## other_names		: create separate and total lists of spieces from all other genera in genera directory

.PHONY : other_names
other_names : genera_names scripts/generate_other_names.sh assembly_summary.txt
	@echo "Need to be done"

## path_gen		: create files with links ftp directories of NCBI, _paths

.PHONY : path_gen
path_gen : */*_names scripts/path_gen.sh assembly_summary.txt
	bash scripts/path_gen.sh


## seq_fetch		: fetch all 'cds' and 'protein' sequences from NCBI, save in 'nseqs' and 'pseqs' directories

.PHONY : seq_fetch
seq_fetch :  path_gen scripts/seq_fetch.sh 
	bash scripts/seq_fetch.sh


## stats_fetch		: check if all sequences fetched (number of links == number of files)

.PHONY : stats_fetch
stats_fetch : */*_links scripts/stats_fetch.sh 
	bash scripts/stats_fetch.sh


## extract_pol-seq	: extract sequence of DNA polymerase I from multi-fasta files

.PHONY : extract_pol-seq
extract_pol-seq : 
	@echo "-------------------------------------------------------------------"
	@echo "Extracting sequence of DNA polymerase I from multi-fasta files..."
	@echo "-------------------------------------------------------------------"
	awk '/DNA polymerase I]/' RS='>' $(FILE)
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"


## clean_generated_data	: clean data files generated in this project

.PHONY : clean_generated_data
clean_generated_data :
	@echo "-------------------------------------------------------------------"
	@echo "Cleaning all data files that are generated in this project..."
	@echo "-------------------------------------------------------------------"
	rm -f *names *taxids */*names */*taxids *paths */*paths */nseqs */pseqs
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"


## clean_downloaded_data	: clean data files downloaded from external sources

.PHONY : clean_downloaded_data
clean_downloaded_data :
	@echo "-------------------------------------------------------------------"
	@echo "Cleaning all data files downloaded from external sources..."
	@echo "-------------------------------------------------------------------"
	rm -f assembly_summary.txt */nseq/* */pseq/*
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"


## clean_all		: clean all data files (downloaded and generated)

.PHONY : clean_all
clean_all : clean_downloaded_data clean_generated_data


## help			: view this help

.PHONY : help
help : Makefile
	@echo 
	@echo "USAGE:	make [command]"
	@echo 
	@echo " commands		: what happens"
	@echo 
	@sed -n 's/^##//p' $<
	@echo 
