#!/bin/bash
#SBATCH --job-name=vep
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=32    
#SBATCH --time=50-00:00:00
#SBATCH --mem=198G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null

set -euo pipefail

EXEC1=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep/p013_annotation.sh
EXEC2=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p015_annotation.R
SCRIPT_NAME=$(basename $EXEC1 .sh)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
bash $EXEC1
Rscript $EXEC2
echo 'end at:'
date
