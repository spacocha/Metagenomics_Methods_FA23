#Using the contigs.fasta file from the assembler, call Prokaryotic genes with Prodigal

sbatch prodigal_gene_calls_redo.csh

#output will be assembledContigs.all_genes.redo.fa and assembledContigs.all_proteins.redo.faa
#This can be used to classify which genes they are using GhostKoala
#To use the online service, the files need to be under the size limit.
#For a large assembly this can be broken up with split_fasta.pl

perl ./split_fasta.pl assembledContigs.all_proteins.faa 13

#However, this actually makes the first few files too large because they are typically longer
#You might need to break those into two files
#e.g.
#perl ./split_fasta.pl assembledContigs.all_proteins.1.faa 2

#Submit to GhostKoala:
#https://www.kegg.jp/ghostkoala/
# Make sure to check off genus_prokaryotes + family_eukaryotes + viruses
#When the results from back, make sure to give them all unique names and save them in a separate folder (e.g. GhostKoala)
#results are the genes (assembledContigs.all_proteins.redo.faa) and their KOs only (e.g. assembledContigs.all_proteins.redo.1.1.ko.txt)
#along with the taxa (e.g. assembledContigs.all_proteins.redo.1.1.taxa)

#The taxonomic assignments are not as strict as the KO assignments
#Fix the taxonomic assignments to match the KO assignments
#use tcsh for foreach capacity
foreach f ( *[0-9].ko.txt )
set base=`basename ${f} .ko.txt`
perl extract_taxa_from_KO_txt.pl $f ${base}.taxa > ${base}.taxa.good.txt
end

#Files with *taxa.good.txt match the KOs and any that didn't are discarded
