#!/usr/bin/env bash
#SBATCH --mem 60G
#SBATCH --nodes 1
#SBATCH --tasks 1
#SBATCH --cpus-per-task 24
#SBATCH --time 16:00:00
#SBATCH --gres lscratch:300

threads=22

module load xHLA/2018-04-04
module load bedtools/2.30.0
module load samtools/1.16.1
module load edirect/17.1
module load bwa/0.7.17

# SAMPLE=436
GITDIR=$(realpath .)
SAMPLE=${SLURM_ARRAY_TASK_ID}
DATADIR='/data/CARD_proteomics/Psomagen/AN00022036'
READ1="${DATADIR}/${SAMPLE}_1.fastq.gz"
READ2="${DATADIR}/${SAMPLE}_2.fastq.gz"
CHR6BAM="${SAMPLE}-hg38.chr6.bam"


# work in lscratch
TMPDIR="/lscratch/${SLURM_JOB_ID}"
cd "${TMPDIR}" || exit 1


# # Set up xHLA directory 
cp -r ${GITDIR}/HLA . && cd HLA


# map reads to chr6 reference for xHLA genotyping
bwa mem -t ${threads} \
'data/chr6/hg38.chr6.fna' \
${READ1} \
${READ2} | \
samtools view -b - | sambamba sort -t ${threads} -o ${CHR6BAM} /dev/stdin && \
sambamba index ${CHR6BAM}


# extract chr6:29844528-33100696
samtools view -o ${SAMPLE}-HLA.bam -b ${CHR6BAM} chr6:29844528-33100696
sambamba index ${SAMPLE}-HLA.bam


cp ${SAMPLE}-HLA.bam ${DATADIR}/HLA_BAMS/${SAMPLE}-HLA.bam
cp ${SAMPLE}-HLA.bam.bai ${DATADIR}/HLA_BAMS/${SAMPLE}-HLA.bam.bai

