#!/bin/bash
#SBATCH --job-name=vep
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=32    
#SBATCH --time=50-00:00:00
#SBATCH --mem=242G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null
#SBATCH --array=1-23

echo "Task ${SLURM_ARRAY_TASK_ID} (Job ID: ${SLURM_JOB_ID}, Array Job ID: ${SLURM_ARRAY_JOB_ID}) is trying to run the script..."
EXEC="/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep/p013_vep_chr${SLURM_ARRAY_TASK_ID}.sh"
SCRIPT_NAME=$(basename $EXEC .sh)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
bash $EXEC
echo 'end at:'
date
