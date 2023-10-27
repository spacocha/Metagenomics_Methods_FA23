#!/bin/bash -l

#SBATCH

#SBATCH --job-name=SPDMainstem
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24

module load spades/3.15.5
SPADES=spades.py
FWD_FQ=./all_s1_pe.fastq
REV_FQ=./all_s2_pe.fastq
SE_FQ=./all_se.fastq
OUT_DIR=assembledContigs_redo

$SPADES --restart-from last -o $OUT_DIR --threads 24 --memory 1000

