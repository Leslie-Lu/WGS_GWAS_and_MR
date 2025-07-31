#!/bin/bash
#SBATCH --job-name=tw_test
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32  
#SBATCH --time=04-00:00:00
#SBATCH --mem=100G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p021_pca_tw_test.perl
SCRIPT_NAME=$(basename $EXEC .perl)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
perl $EXEC
echo 'end at:'
date
