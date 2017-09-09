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
	
