#!/usr/bin/env bash

#SBATCH --job-name=condition_asso
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=61    
#SBATCH --time=88-00:00:00
#SBATCH --mem=160G
#SBATCH --partition=bigmem
#SBATCH --output=/dev/null

EXEC="/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p122_condition_asso_analysis.sh"
SCRIPT_NAME=$(basename $EXEC .sh)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
source "$HOME/.bashrc"
bash "$EXEC"
echo 'end at:'
date

