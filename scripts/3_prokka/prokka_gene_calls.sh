#!/bin/bash -l

#SBATCH --job-name=prokka
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24

echo "Timestamp:"
date
echo "Starting prodigal"

module load prokka/1.14.5
module load blast-plus/2.13.0

prokka --centre CBsamples --compliant --dbdir ~/scratch/databases/prokka/db assembledContigs_redo/contigs.fasta --force

echo "Finished; timestamp"
date
