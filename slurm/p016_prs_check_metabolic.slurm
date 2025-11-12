#!/bin/bash
#SBATCH --job-name=prs_check
#SBATCH --nodes=1
#SBATCH --cpus-per-task=64  
#SBATCH --time=04-00:00:00
#SBATCH --mem=230G
#SBATCH --partition=inspur
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/p016_prs_check_metabolic.slurm
SCRIPT_NAME=$(basename $EXEC .slurm)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
source "$HOME/.bashrc"
awk '{print $1 "\t" $1}' /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T005_MR_metabolite_EuropeanPrePCAID.txt \
  > /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T005_MR_metabolite_EuropeanPrePCAID_v2.txt
threads=$(nproc)
plink2 \
  --pfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
  --keep /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T005_MR_metabolite_EuropeanPrePCAID_v2.txt \
  --extract /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20251104_v3.txt \
  --score /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_prs_input_files_metabolic_in_wide_format.txt 1 2 header-read cols=scoresums list-variants \
  --score-col-nums 3-227 \
  --memory 162276 \
  --threads $threads \
  --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/metabolic/Euro_MR_metabolic_PRS
wc -l /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/metabolic/Euro_MR_metabolic_PRS.sscore.vars
wc -l /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/metabolic/Euro_MR_metabolic_PRS.sscore
awk -F'\t' '{print NF; exit}' /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/metabolic/Euro_MR_metabolic_PRS.sscore
awk -F'\t' 'NR==1 {for(i=1;i<=NF;i++) print i, $i}' /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/metabolic/Euro_MR_metabolic_PRS.sscore > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/metabolic/Euro_MR_metabolic_PRS_colnames.txt
echo 'end at:'
date
