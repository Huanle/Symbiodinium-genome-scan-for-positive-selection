# Symbiodinium-genome-scan-for-positive-selection
scripts, commands used for positive selection analysis of Symbiodinium genomes and dinoflagellate transcriptomes.
Analyses results have been published: https://www.biorxiv.org/content/early/2017/10/05/198762; DOI:10.1101/198762 


# Commands
1. prepare fasta sequences of amino acids and CDS (coding) sequences 
this is to format sequence IDs in the '>Species_ID|sequence_ID' style. This can be done using 'orthomclAdjustFasta' - an Orthomcl (v2+) utility or simply with unix sed command.

sed 's/>/>Species_ID|/' <seqeunce_file> > reformated.seq 

***you can do some filtering using orthomcl utility orthomclFilterFasta if you wish.***

2. 
