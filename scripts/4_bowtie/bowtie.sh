#!/bin/bash -l

#SBATCH

#SBATCH --job-name=bowtie2
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --partition=shared

module load bowtie2/2.3.4

echo "Startin bowtie2-build"
date
#cp ../assembledContigs_redo/contigs.fasta .
#gzip contigs.fasta
bowtie2-build --large-index contigs.fasta.gz contig_index

echo "Completed bowtie2-build"
date

