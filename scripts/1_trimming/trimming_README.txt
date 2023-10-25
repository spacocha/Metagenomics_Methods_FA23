#!/bin/bash -l

#Start with a list of all of the fastq files from the sequencing machine
#These are in the forward and reverse files
#You can create the list using the ls
#For example, in the folder (e.g. Raw_data/sprehei1_146738/FASTQ) with all of the fastq files
ls *_1.fastq.gz > ../forward1
ls *_2.fastq.gz > ../reverse1

#since they are gzipped, you want to unzip before using
#Change the names in the files to remove .gz
perl ./find_remove.pl forward1 \.gz >forward
perl ./find_remove.pl reverse1 \.gz > reverse

#Also make the output folder where the trimmed files go
mkdir Trimmed_FASTQ

#Now, you can use multiple processors to do the trimming for each file in parallel
sbatch -o slurm-%A_%a.out --array=1-24 trimmer.sh

#Repeat for any additional sequence folders
#When all jobs are complete, contatenate them together into one file
#e.g.
#cat ../../Raw_data/sprehei1_146738/Trimmed_FASTQ/*s1_pe ../../Raw_data/sprehei1_146742/Trimmed_FASTQ/*s1_pe > all_s1_pe.fastq
#cat ../../Raw_data/sprehei1_146738/Trimmed_FASTQ/*s2_pe ../../Raw_data/sprehei1_146742/Trimmed_FASTQ/*s2_pe > all_s2_pe.fastq
#cat ../../Raw_data/sprehei1_146738/Trimmed_FASTQ/*se ../../Raw_data/sprehei1_146742/Trimmed_FASTQ/*se > all_se.fastq

#These contain all of the cleaned, trimmed fastq files to be used in assembly
#all_s1_pe.fastq, all_s2_pe.fastq, and all_se.fastq

