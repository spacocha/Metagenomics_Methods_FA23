#!/bin/bash -l

#SBATCH
#SBATCH --job-name=bowtie-quant
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
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

bowtie2 -x $INDEX -1 $FWD_FQ -2 $REV_FQ -U ${SE1},${SE2} -S $OUTPUT
samtools view -bS $OUTPUT > ${OUTPUT}.bam
samtools sort ${OUTPUT}.bam -o ${OUTPUT}.sorted.bam
bedtools bamtobed -i ${OUTPUT}.sorted.bam > ${OUTPUT}.sorted.bed
bedtools intersect -a ${BEDFILE} -b ${OUTPUT}.sorted.bed -wo > ${OUTPUT}.intersect.bed
bedtools groupby -i ${OUTPUT}.intersect.bed -g 4 -c 11 -o sum > ${OUTPUT}.grouped.intersect.bed
#make total reads
cat $FWD_FQ $REV_FQ ${SE1} ${SE2} | grep "^@180607"  | wc -l > ${OUTPUT}.total.reads
perl translate_intersect_coverage_contig.pl  ${OUTPUT}.total.reads ${OUTPUT}.grouped.intersect.bed ${ALL_GENES} > ${OUTPUT}.RPM.txt

echo "Complete: bowtie2 task $SLURM_ARRAY_TASK_ID"
date

