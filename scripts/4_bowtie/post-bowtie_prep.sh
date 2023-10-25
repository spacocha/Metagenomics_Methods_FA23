#!/bin/bash -l

#SBATCH
#SBATCH --job-name=bowtie-quant
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --partition=shared

#merge all of the individual RPM files
ls *RPM.txt > RPM_list.txt
#Although this has a bug that it adds a row with all CPM which needs to be removed
#it was removed by hand in the analysis
perl merge_quant_RPM.pl RPM_list.txt > RPM_final_table.txt
#add KEGG numbers and taxonomy to the entries
ls ../../../Prodigal_gene_calls/GhostKhoala_redo/*.taxa > taxalist
perl add_taxa_to_table.pl taxalist RPM_final_table.txt > RPM_final_table.KO.taxa.txt
#remove any empty entries, only 300K out of 15M were empty
perl remove_zero_genes.pl RPM_final_table.KO.taxa.txt RPM_final_table.KO.taxa.non-zero.txt 

