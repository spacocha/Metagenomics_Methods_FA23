#This document describes how to run bowtie to map reads to contigs.
#Notes
#This method of analysis is best when you have run trimmomatic to remove adapters and to trim your reads before assembly. Bowtie can take both paired and single end data simultaneously, which is something that other programs, like salmon, doesn't do well.

#This does not map reads as well as salmon (salmon is more sensitive and seems to map more reads), but in an analysis of how data changes over our entire dataset from both salmon and bowtie mapping, the results were similar. However, when comparing the results for a small subset of reads, salmon mapped more reads (unknown whether either was mapped correctly).

#Overview
#Take reads in fastq format and assembly in fasta format, map reads to assembly with bowtie, then use samtools and bedtools to identify how the reads map to gene locations, predicted by prodigal. These scrips also assume you have KEGG IDs for the genes, which can also be mapped.

#Conditions
#1.) Assembled contigs in fasta format (e.g. contigs.fasta from metaSPADES)
#2.) Both single end and paired end reads (e.g. files in Trimmed_fasta folders from trimmomatic)
#3.) Gene calls from Prodigal (e.g. assembledContigs.all_genes.redo.faa)
#4.) KEGG IDs and taxonomic assignments for genes from GhostKoala (e.g. assembledContigs.all_proteins.redo.1.1.ko.txt and assembledContigs.all_proteins.redo.1.1.taxa)

#Steps
#1.) Use bowtie.sh script to make the build (i.e. bowtie2-build) from assembled contigs
sbatch bowtie.sh

#output of the build is to have a file contig_index that you can use for the mapping

#2.) Prepare lists of the forward reads (in this case which have format *_1.fastq forward, *_2.fastq reverse) as follows
#You need to use all of the libraries individually to know which library it comes from
#Can't use all_se.fastq for example, since the library distribution would be lost
#ls Trimmed_FASTQ/*_1.fastq > forward
#ls Trimmed_FASTQ/*2.fastq > reverse
#ls Trimmed_FASTQ/*s1_se.fastq > se1
#ls Trimmed_FASTQ/*s2_se.fastq > se2
#However it is done, you need to make sure they have the same order for each sequenced file (which might be an issue for a small sample or subset, which might be missing one of these files)

#3.) Make a list of base names somehow. In this case, taking one of the files and removing the beginning and end parts
perl ./find_remove.pl forward ../../../salmon_key_KO/Trimmed_FASTQ/ > output1
perl ./find_remove.pl output1 _1.fastq_s1_pe_1.fastq > output

#4.) Run the bowtie mapping program as an array on MARCC (this will have to be configured differently for different systems or if not using SLURM or arrays)
sbatch  -o slurm-%A_%a.out --array=1-47 bowtie2_array_5.sh

#The output of each of these will be the q20.TPM.txt files for each library

#5.) Merge the output from each of the different files/libraries
#This might require more memory than normally, so make sure to use extra memory
interact -t 2:00:00 -p shared -c 24
#Make a list of all of the *.q20.TPM.txt files
ls *q20.TPM.txt > TPM_list.txt 

#Merge these different files into one gene by library table
merge_quant_TPM.pl TPM_list.txt > TPM_final_table.txt

#Now you can add the KO information to the table
ls ../../../Prodigal_gene_calls/GhostKhoala_redo/*.ko.txt > KOlist
perl add_KEGG_to_table.pl KOlist2 TPM_final_table.txt > TPM_final_table.KO.txt

#You might also want to add both KO and taxa info
ls ../../../Prodigal_gene_calls/GhostKhoala_redo/*.taxa.good.txt > goodtaxalist2
perl add_taxa_to_table.pl goodtaxalist2 TPM_final_table.txt > TPM_final_table.KO.taxa.good.txt


