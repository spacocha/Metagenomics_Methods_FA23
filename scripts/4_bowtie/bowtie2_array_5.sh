#!/bin/bash -l

#SBATCH
#SBATCH --job-name=bowtie-quant
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --partition=shared

#submit as an array with the number of lines of forward or reverse file

module load bowtie2/2.3.4
module load samtools/1.9
module load bedtools/2.27.0

#choose the fastq file to work on
FWD_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" forward`
REV_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" reverse`
SE1=`awk "NR==$SLURM_ARRAY_TASK_ID" se1`
SE2=`awk "NR==$SLURM_ARRAY_TASK_ID" se2`
TRIMMED="../../../../salmon_key_KO/Trimmed_FASTQ/"
OUTPUT=`awk "NR==$SLURM_ARRAY_TASK_ID" output`
INDEX="../contig_index"
BEDFILE="assembledContigs.all_genes.bed"
ALL_GENES="../../../Prodigal_gene_calls/assembledContigs.all_genes.redo.fa"

#This assumes they are zipped but you provide the unzipped name

echo "Start: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

#bowtie was run for coverage, doesn't have to be repeated
bowtie2 -x $INDEX -U ${FWD_FQ},${REV_FQ},${SE1},${SE2} -S $OUTPUT
#instead, use the one in PE_Quant
#only report 99% hits (MAPQ 20)
samtools view -bS -q 20 $OUTPUT > ${OUTPUT}.q20.bam
samtools sort ${OUTPUT}.q20.bam -o ${OUTPUT}.sorted.q20.bam
bedtools bamtobed -i ${OUTPUT}.sorted.q20.bam > ${OUTPUT}.sorted.q20.bed
bedtools intersect -a ${BEDFILE} -b ${OUTPUT}.sorted.q20.bed -wo > ${OUTPUT}.intersect.q20.bed
#count only fragments with count_distinct (i.e. two sides of same read is 1 fragment), not coverage with sum
bedtools groupby -i ${OUTPUT}.intersect.q20.bed -g 4 -c 11 -o count > ${OUTPUT}.grouped.intersect.q20.bed
#make total mapped reads from the bowtie output (which includes all mapped- not q20 only)
grep "^180607_" ${OUTPUT} | grep "NODE" | wc -l  > ${OUTPUT}.total.mapped.reads
perl translate_intersect_RPKM_contig.pl  ${OUTPUT}.total.mapped.reads ${OUTPUT}.grouped.intersect.q20.bed ${ALL_GENES} > ${OUTPUT}.q20.RPKM.txt
perl translate_intersect_RPKM_to_TPM.pl ${OUTPUT}.q20.RPKM.txt > ${OUTPUT}.q20.TPM.txt

echo "Complete: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

