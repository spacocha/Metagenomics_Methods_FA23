#!/bin/bash -l

#SBATCH
#SBATCH --job-name=bowtie-quant
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4

#submit as an array with the number of lines of forward or reverse file

module load bowtie2/2.4.2
module load samtools/1.16.1
module load bedtools2/2.30.0

#add the folder to your path that contains the scripts below
#You can find this by going into the scrips folder and typing pwd
export PATH="/scratch/sprehei1/working_space/sprehei1/Lab_6/Metagenomics_Methods_FA23/scripts/4_bowtie:$PATH"


#choose the fastq file to work on
#Make a forward file that contains all of the forward paired end read files you want to map
#From PE_Quant folder, run these commands
#ls ../../Trimmed_data/*_s1_pe > forward
FWD_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" forward`
#Make a reverse file in PE_Quant 
#ls ../../Trimmed_data/*_s2_pe > reverse
REV_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" reverse`

#Make a single end file
#ls ../../Trimmed_data/*_s1_se > se1
SE1=`awk "NR==$SLURM_ARRAY_TASK_ID" se1`

#Make a single end reverse file
#ls ../../Trimmed_data/*s2_se > se2
SE2=`awk "NR==$SLURM_ARRAY_TASK_ID" se2`

#Make an output file that has the output names you want to use
#echo "SRR14874048" > output
#echo "SRR14874049" >> output
OUTPUT=`awk "NR==$SLURM_ARRAY_TASK_ID" output`

#This will be done with bowtie.sh and depend on the index name used in that file
INDEX="../contigs_index"

#Make a bed file for all of the genes observed
GFFFILE=PROKKA_all_gene.bed
prokka2bed.pl ../../PROKKA*/PROKKA*.gff > $GFFFILE

#Add a unique string for each read that can be used to count mapped reads
#Something specific about the contig
REGEX1="CBsamples"
#Something specific about the read
REGEX2=${OUTPUT}


echo "Start: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

#bowtie index had to be made separately, with bowtie.sh (only once)
bowtie2 -x $INDEX -U ${FWD_FQ},${REV_FQ},${SE1},${SE2} -S $OUTPUT

#only report 99% hits (MAPQ 20)
samtools view -bS -q 20 $OUTPUT > ${OUTPUT}.q20.bam
samtools sort ${OUTPUT}.q20.bam -o ${OUTPUT}.sorted.q20.bam
bedtools bamtobed -i ${OUTPUT}.sorted.q20.bam > ${OUTPUT}.sorted.q20.bed
bedtools intersect -a ${GFFFILE} -b ${OUTPUT}.sorted.q20.bed -wo > ${OUTPUT}.intersect.q20.bed
#count only fragments with count_distinct (i.e. two sides of same read is 1 fragment), not coverage with sum
bedtools groupby -i ${OUTPUT}.intersect.q20.bed -g 4 -c 11 -o count > ${OUTPUT}.grouped.intersect.q20.bed
#make total mapped reads from the bowtie output (which includes all mapped- not q20 only)
#REGEX IS UNIQUE FOR EACH RUN
grep "${REGEX1}" ${OUTPUT} | grep "${REGEX2}" | wc -l  > ${OUTPUT}.total.mapped.reads
translate_intersect_RPKM_contig.pl  ${OUTPUT}.total.mapped.reads ${OUTPUT}.grouped.intersect.q20.bed ${GFFFILE} > ${OUTPUT}.q20.RPKM.txt
translate_intersect_RPKM_to_TPM.pl ${OUTPUT}.q20.RPKM.txt > ${OUTPUT}.q20.TPM.txt

echo "Complete: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

