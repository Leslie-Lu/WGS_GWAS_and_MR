#!/bin/bash
#SBATCH --job-name=smartpca_euro
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8          
#SBATCH --time=50-00:00:00
#SBATCH --mem=902G
#SBATCH --partition=bigmem
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p010_smartpca_european_outcome_cc_cin3.sh
SCRIPT_NAME=$(basename $EXEC .sh)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
bash $EXEC
echo 'end at:'
date
