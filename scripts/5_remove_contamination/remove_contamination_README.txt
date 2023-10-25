#remove any genes that have a larger average value in the negative controls than in the samples
#Control samples are indicated in the metadata file with the column (5) and indicated as Control compared to Mainstem samples
perl remove_negative_genes.pl ../../bowtie_dir/contig_bowtie/RPKM_dir/TPM_final_table.KO.txt ../Metagenomic_metadata_master_032122.txt2 5 Control Mainstem > TPM_final_table.KO.neg.txt

#Now merge individual genes by KO values that are already at the end of the table
perl merge_by_KO.pl TPM_final_table.KO.neg.txt > TPM_final_table.KO.neg.merged.txt

#Add taxonomic names to the table
perl ../add_taxa_to_table.pl goodtaxalist2 TPM_final_table.KO.neg.txt > TPM_final_table.KO.neg.good.taxa.txt



