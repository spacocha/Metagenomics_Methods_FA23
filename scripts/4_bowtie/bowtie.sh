#!/bin/bash -l

#SBATCH

#SBATCH --job-name=bowtie2
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12


module load bowtie2/2.4.2

echo "Startin bowtie2-build"
date
mkdir bowtie_contig
cp ./assembledContigs_redo/contigs.fasta bowtie_contig/contigs.fasta
gzip bowtie_contig/contigs.fasta
bowtie2-build --large-index bowtie_contig/contigs.fasta.gz bowtie_contig/contig_index

echo "Completed bowtie2-build"
date

