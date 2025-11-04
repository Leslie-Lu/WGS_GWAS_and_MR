#!/bin/bash -l
#SBATCH --job-name=liftover_mqtls
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40    
#SBATCH --time=88-00:00:00
#SBATCH --mem=102G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null

EXEC="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/p017_liftover_mqtls.slurm"
SCRIPT_NAME=$(basename $EXEC .slurm)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
source /share/home/lsy_luzhen/software/miniconda3/bin/activate base
liftOver \
    /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/NMR/mqtls_variants_hg19.bed \
    /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/NMR/hg19ToHg38.over.chain.gz \
    /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/NMR/mqtls_variants_hg38.bed \
    /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/NMR/mqtls_unmapped.bed
conda deactivate
echo 'end at:'
date
