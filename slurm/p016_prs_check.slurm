#!/bin/bash
#SBATCH --job-name=prs_check
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40  
#SBATCH --time=04-00:00:00
#SBATCH --mem=230G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/p016_prs_check.slurm
SCRIPT_NAME=$(basename $EXEC .slurm)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
# grep "^1:145711327:" /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted.ids
# file /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted.txt
# dos2unix /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted.txt
# sort /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted.txt -o /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted_v2.txt
# sort /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted.ids -o /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids
# comm -23 /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted_v2.txt /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids > /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_unmatch_20250929.txt
# comm -23 /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_sorted_v2.txt /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids | wc -l

# file /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_v2_sorted.txt
# dos2unix /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_v2_sorted.txt
# sort /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_v2_sorted.txt -o /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_v2_sorted_v2.txt
# comm -23 /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_v2_sorted_v2.txt /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids > /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_unmatch_20250929_v2.txt
# comm -23 /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_v2_sorted_v2.txt /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VariantIDs/ref_rsID_sorted_v2.ids | wc -l

threads=$(nproc)
plink2 \
  --pfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
  --keep /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCAID.txt \
  --extract /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_total_rsID_20250929_v3.txt \
  --score /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T006_prs_input_files_proteomic_in_wide_format.txt 1 2 header-read cols=scoresums list-variants \
  --score-col-nums 3-2419 \
  --memory 239276 \
  --threads $threads \
  --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic/Euro_MR_proteomic_PRS
echo 'end at:'
date
