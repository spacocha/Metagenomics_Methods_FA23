#!/bin/bash -l

#SBATCH

#SBATCH --job-name=trimmo38
#SBATCH --time=2:00:00

#This shouldn't change
module load trimmomatic/0.39
EX_LOC=trimmomatic
AD_LOC=~/scratch/databases/lib/NexteraPE-PE.fa

#This is where to find the raw data
LIB_DIR=./raw_data

#Make sure trimmed folder already exists
#mkdir ./Trimmed_data

ASSEM=./Trimmed_data

#forward.txt and reverse.txt contain files to trim
#make with the following commands
#In ./raw_data
#ls *_1.fastq > forward.txt
#ls *_2.fastq > reverse.txt
FWD_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" forward.txt`
REV_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" reverse.txt`

#Assuming the files are not zipped from NCBI
#remove this step if already zipped
gunzip $LIB_DIR/${FWD_FQ}.gz
gunzip $LIB_DIR/${REV_FQ}.gz

#This is the trimmomatic commands
#Change if necessary
$EX_LOC PE -threads 0 -phred33 \
$LIB_DIR/$FWD_FQ  $LIB_DIR/$REV_FQ \
$ASSEM/${FWD_FQ}_s1_pe $ASSEM/${FWD_FQ}_s1_se $ASSEM/${REV_FQ}_s2_pe $ASSEM/${REV_FQ}_s2_se \
ILLUMINACLIP:$AD_LOC:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:33 MINLEN:50

echo "Complete: trimmomatic $SLURM_ARRAY_TASK_ID"
