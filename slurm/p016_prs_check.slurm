#!/bin/bash
#SBATCH --job-name=prs_check
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32  
#SBATCH --time=04-00:00:00
#SBATCH --mem=100G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/p016_prs_check.slurm
SCRIPT_NAME=$(basename $EXEC .slurm)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
grep "^1:145711327:" /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted.ids
file /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted.txt
dos2unix /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted.txt
sort /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted.txt -o /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted_v2.txt
sort /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted.ids -o /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids
comm -23 /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted_v2.txt /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids > /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_unmatch_20250929.txt
comm -23 /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted_v2.txt /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids | wc -l
echo 'end at:'
date
