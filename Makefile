

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




## names			: create list of spieces from genus Geobacillus + Bacillus

.PHONY : names
names : geobac_names bac_names


## geobac_names		: create list of spieces from genus Geobacillus

.PHONY : geobac_names
geobac_names : assembly_summary.txt scripts/names.sh
	bash scripts/names.sh Geobacillus


## bac_names		: create list of spieces from genus Bacillus

.PHONY : bac_names
bac_names : assembly_summary.txt scripts/names.sh
	bash scripts/names.sh Bacillus



## path_gen		: create files with links ftp directories of NCBI, _paths

.PHONY : path_gen
path_gen : names scripts/path_gen.sh assembly_summary.txt
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
	bash scripts/extract_pol-seq.sh


## align_seq		: align all DNA and protein sequences of target (DNA polymerase I)

.PHONY : align_seq
align_seq : 
	bash scripts/align_seq.sh


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
