#!/bin/bash
#SBATCH --job-name=prs_check_only_cis
#SBATCH --nodes=1
#SBATCH --cpus-per-task=64  
#SBATCH --time=04-00:00:00
#SBATCH --mem=163G
#SBATCH --partition=inspur
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/p016_prs_check_only_cis.slurm
SCRIPT_NAME=$(basename $EXEC .slurm)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
source "$HOME/.bashrc"
awk '{print $1 "\t" $1}' /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCAID.txt \
  > /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCAID_v2.txt
threads=$(nproc)
plink2 \
  --pfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
  --keep /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCAID_v2.txt \
  --extract /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_only_cis_v3.txt \
  --score /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_prs_only_cis_input_files_proteomic_in_wide_format.txt 1 2 header-read cols=scoresums list-variants \
  --score-col-nums 3-1910 \
  --memory 162276 \
  --threads $threads \
  --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/Euro_MR_proteomic_PRS_only_cis
wc -l /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/Euro_MR_proteomic_PRS_only_cis.sscore.vars
wc -l /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/Euro_MR_proteomic_PRS_only_cis.sscore
awk -F'\t' '{print NF; exit}' /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/Euro_MR_proteomic_PRS_only_cis.sscore
awk -F'\t' 'NR==1 {for(i=1;i<=NF;i++) print i, $i}' /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/Euro_MR_proteomic_PRS_only_cis.sscore > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/Euro_MR_proteomic_PRS_only_cis_colnames.txt
echo 'end at:'
date
