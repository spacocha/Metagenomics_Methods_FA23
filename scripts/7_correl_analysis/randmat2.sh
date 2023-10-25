#!/bin/bash -l

#SBATCH

#SBATCH --job-name=randmat
#SBATCH -A sprehei1_bigmem

echo "Starting randomization matrix"
date
perl ../make_rand_mat.pl TPM_final_table.KO.neg.merged.txt > TPM_final_table.KO.neg.merged.rand.txt
echo "Completed rand mat"
date

