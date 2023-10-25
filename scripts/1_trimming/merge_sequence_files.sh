#!/bin/bash -l

#SBATCH

#SBATCH --job-name=trimmo38
#SBATCH --time=2:00:00

#merge together all of the trimmed sequence reads, whether paired or single end
cat ./Trimmed_data/*s1_pe > all_s1_pe.fastq
cat ./Trimmed_data/*s2_pe  > all_s2_pe.fastq
cat ./Trimmed_data/*se  > all_se.fastq

#Use these files as input to SPADES

