#Starting with the TPM_final_table.KO.txt file from bowtie, remove any genes that are more abundant in the negative on average than the positive samples
#Metagenomic_metadata_master_032122.txt2 is the metadata file associated with this
#5 is the column in that file which indicates the type of file
#Control are the samples that should not have genes in them. Since they do, make sure they are not more abundant than in the actual samples
#Mainstem are the real environmental samples
perl remove_negative_genes.pl TPM_final_table.KO.txt Metagenomic_metadata_master_032122.txt2 5 Control Mainstem > TPM_final_table.KO.neg.txt

#Now merge by KO
perl merge_by_KO.pl TPM_final_table.KO.neg.txt > TPM_final_table.KO.neg.merged.txt

#Add taxa to this table
perl add_taxa_to_table.pl goodtaxalist2 TPM_final_table.KO.neg.txt > TPM_final_table.KO.neg.good.taxa.txt



