#!/bin/bash -l

#SBATCH
#SBATCH --job-name=bowtie-quant
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --partition=shared

#prepare a list of all the reads (paired and se) that I want to map
ls ../../../salmon_key_KO/Trimmed_FASTQ/*1.fastq > forward
ls ../../../salmon_key_KO/Trimmed_FASTQ/*2.fastq > reverse
perl ~/bin/beagle_bin/find_remove.pl forward ../../../salmon_key_KO/Trimmed_FASTQ/ > output
perl ~/bin/beagle_bin/find_remove.pl output _1.fastq_s1_pe_1.fastq > output2
mv output2 output
ls ../../../salmon_key_KO/Trimmed_SE_FASTQ/*s1_se.fastq > se1
ls ../../../salmon_key_KO/Trimmed_SE_FASTQ/*s2_se.fastq > se2

#prepare the overlap of genes with full assembly
perl prodigal2bed.pl ../../../Prodigal_gene_calls/assembledContigs.all_genes.redo.fa > assembledContigs.all_genes.bed
