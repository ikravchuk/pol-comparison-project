

## setup			: setup all dependencies, download 
.PHONY : setup
setup :
	@echo "setup should be created ;)"


## assembly_summary.txt	: download summary for all Bacteria genomes from NCBI

# Get assembly summary for all genomes for Bacteria from NCBI
# ftp://ftp.ncbi.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
# curl -O ftp://ftp.ncbi.nih.gov/genomes/genbank/bacteria/assembly_summary.txt

assembly_summary.txt :
	@echo "-------------------------------------------------------------------"
	@echo "Getting assembly summary for all Bacteria genomes from NCBI..."
	@echo "-------------------------------------------------------------------"
	curl -O ftp://ftp.ncbi.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"
	
## names2taxids		: creates 'taxids' file based on 'names' file
.PHONY : names2taxids
name2taxids : names
	@echo "-------------------------------------------------------------------"
	@echo "Creating file with taxids for spices listed in 'names'..."
	@echo "-------------------------------------------------------------------"
	taxonkit name2taxid < $< | cut -f 2 > taxids	
	@echo "-------------------------------------------------------------------"
	@echo "Done"
	@echo "-------------------------------------------------------------------"

## help			: view this help
.PHONY : help
help : Makefile
	@echo 
	@echo "USAGE:	make [command]"
	@echo "..................................................................."
	@echo "	command		:	what happens"
	@echo "..................................................................."
	@sed -n 's/^##//p' $<
	@echo 
