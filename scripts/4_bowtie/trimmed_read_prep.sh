#!/bin/bash -l

#SBATCH
#SBATCH --job-name=bowtie-quant
#SBATCH --time=2:00:00
#SBATCH --nodes=1

mkdir ./bowtie_contig/PE_Quant
#prepare a list of all the reads (paired and se) that I want to map
ls ./Trimmed_data/*1.fastq_s1_pe > ./bowtie_contig/PE_Quant/s1_pe.txt
ls ./Trimmed_data/*2.fastq_s2_pe > ./bowtie_contig/PE_Quant/s2_pe.txt
perl ~/bin/beagle_bin/find_remove.pl s1_pe.txt ./Trimmed_data/ > ./bowtie_contig/PE_Quant/output
perl ~/bin/beagle_bin/find_remove.pl output _1.fastq_s1_pe > ./bowtie_contig/PE_Quant/output2
mv ./bowtie_contig/PE_Quant/output2 ./bowtie_contig/PE_Quant/output
ls ./Trimmed_data/*s1_se > ./bowtie_contig/PE_Quant/se1.txt
ls ./Trimmed_data/*s2_se > ./bowtie_contig/PE_Quant/se2.txt

#prepare the overlap of genes with full assembly
perl prodigal2bed.pl ./PROKKA_*/PROKKA_*.fna > ./bowtie_contig/PE_Quant/assembledContigs.all_genes.bed
