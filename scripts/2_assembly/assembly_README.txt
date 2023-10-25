#Use the output of the trimmer.sh script 
#all_s1_pe.fastq, all_s2_pe.fastq, all_se.fastq

#These will be used in MetaSPADES assembly

sbatch SPDS_assemble6.sh

#If it fails before it's complete, just restart with this script
#sbatch SPDS_assemble7.sh

#output is the contigs.fasta file that should be written when complete
#assembly stats are also helpful

