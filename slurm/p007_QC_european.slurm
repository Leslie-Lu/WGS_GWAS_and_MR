#!/bin/bash
#SBATCH --job-name=plink_merge
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --time=17-00:00:00
#SBATCH --mem=409600
#SBATCH --partition=inspur
#SBATCH --output=%j.out
EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p007_QC_european.sh
echo 'start at:'
date
bash $EXEC
echo 'end at:'
date
