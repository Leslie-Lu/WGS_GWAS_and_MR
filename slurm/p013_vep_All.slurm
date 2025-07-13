#!/bin/bash
#SBATCH --job-name=vep
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=32    
#SBATCH --time=50-00:00:00
#SBATCH --mem=242G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep/p013_vep_All.sh
SCRIPT_NAME=$(basename $EXEC .sh)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
bash $EXEC
echo 'end at:'
date
