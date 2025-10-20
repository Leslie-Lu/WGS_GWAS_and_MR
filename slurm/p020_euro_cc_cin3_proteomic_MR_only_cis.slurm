#!/bin/bash -l
#SBATCH --job-name=proteomic_MR_only_cis
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8    
#SBATCH --time=88-00:00:00
#SBATCH --mem=158G
#SBATCH --partition=bigmem
#SBATCH --output=/dev/null

EXEC="/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p020_euro_cc_cin3_proteomic_MR_only_cis.r"
SCRIPT_NAME=$(basename $EXEC .r)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
source /share/home/lsy_luzhen/software/miniconda3/bin/activate r-441
Rscript $EXEC
conda deactivate
echo 'end at:'
date
