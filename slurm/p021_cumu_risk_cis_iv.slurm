#!/bin/bash -l
#SBATCH --job-name=cumu_risk_cis_iv
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=64    
#SBATCH --time=88-00:00:00
#SBATCH --mem=150G
#SBATCH --partition=inspur
#SBATCH --output=/dev/null

EXEC="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/p021_cumu_risk_cis_iv.slurm"
SCRIPT_NAME=$(basename $EXEC .slurm)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
source "$HOME/.bashrc"
threads=$(nproc)
# plink2 \
#   --pfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
#   --extract /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/p021_cumu_risk_cis_iv.txt \
#   --recode A \
#   --memory 210000 \
#   --threads $threads \
#   --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/cis_pqtl_genotypes
# plink2 \
#   --pfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
#   --extract /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/p021_cumu_risk_cis_iv.txt \
#   --freq \
#   --memory 150000 \
#   --threads $threads \
#   --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/cis_pqtl_genotypes_freq
plink2 \
  --pfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
  --extract /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/p021_cumu_risk_cis_iv.txt \
  --freq counts \
  --memory 150000 \
  --threads $threads \
  --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/cis_pqtl_genotypes_freq_counts
echo 'end at:'
date
