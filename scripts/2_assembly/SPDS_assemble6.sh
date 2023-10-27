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

#free -mh
#getconf _NPROCESSORS_ONLN

$SPADES --meta -1 $FWD_FQ -2 $REV_FQ -s $SE_FQ -o $OUT_DIR --threads 24 --mem 1000

