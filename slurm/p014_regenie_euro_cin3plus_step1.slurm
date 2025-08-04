#!/bin/bash
#SBATCH --job-name=step1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=64  
#SBATCH --time=50-00:00:00
#SBATCH --mem=498G
#SBATCH --partition=inspur
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p014_regenie_euro_cin3plus.sh
SCRIPT_NAME=$(basename $EXEC .sh)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
bash $EXEC
echo 'end at:'
date
