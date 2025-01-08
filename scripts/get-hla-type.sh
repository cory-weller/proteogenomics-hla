#!/usr/bin/env bash
#SBATCH --mem 20G
#SBATCH --nodes 1
#SBATCH --tasks 1
#SBATCH --cpus-per-task 4
#SBATCH --time 1:00:00
#SBATCH --gres lscratch:50
#SBATCH --partition quick,norm


module load xHLA/2018-04-04

# SAMPLE=436
GITDIR=$(realpath .)
SAMPLE=${SLURM_ARRAY_TASK_ID}
DATADIR='/data/CARD_proteomics/Psomagen/AN00022036'
HLABAM="${DATADIR}/HLA_BAMS/${SAMPLE}-HLA.bam"


# work in lscratch
TMPDIR="/lscratch/${SLURM_JOB_ID}"
cd "${TMPDIR}" || exit 1


# Run xHLA
xhla --sample_id ${SAMPLE} --input_bam_path ${HLABAM} --output_path ${GITDIR}/HLA_TYPES
