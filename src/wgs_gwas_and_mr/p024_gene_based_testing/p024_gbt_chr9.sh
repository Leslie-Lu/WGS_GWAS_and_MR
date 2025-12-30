#!/bin/bash
set -e
###############################################################################################
# PROJECT NAME          : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep.sh
# DESCRIPTION           : Gene-based testing
# DATE CREATED          : 2025-09-03
# INSPIRED BY           : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p014_regenie_euro_cin3plus.sh
# INPUT                 : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p024_gene_based_testing/file_locations.txt
# AUTHOR                : Zhen Lu
################################################################################################
# DATE MODIFIED         : 2025-09-03
# REASON                : Initial version
################################################################################################

source /share/home/lsy_luzhen/software/miniconda3/bin/activate regenie_env

output_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/testing_results"
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
  echo "This directory does not exist, creating now..."
else
  echo "This directory already exists."
fi

echo 'regenie version:'
regenie --version

echo "--------start"
# SET=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/set_list_unique_filtered.txt
# wc -l "$SET"
# SET_MAIN=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/set_list_chr9_no_BMS1P14.txt
# grep -v '^BMS1P14\b' "$SET" > "$SET_MAIN"
# wc -l "$SET_MAIN"
SET_SINGLE=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/set_list_chr9_only_BMS1P14.txt
# grep '^BMS1P14\b' "$SET" > "$SET_SINGLE"
# wc -l "$SET_SINGLE"
# THREADS=4 && \
#   regenie \
#     --step 2 \
#     --pgen /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
#     --chr 9 \
#     --phenoFile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt \
#     --bt \
#     --covarFile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt \
#     --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
#     --strict \
#     --bsize 1000 \
#     --firth --approx \
#     --threads $THREADS \
#     --pred /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step1/regenie_step1_euro_cin3plus_pred.list \
#     --use-null-firth /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step1/regenie_step1_euro_cin3plus_firth.list \
#     --anno-file /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/anno_file_unique_filtered.txt \
#     --set-list "$SET_MAIN" \
#     --mask-def /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/mask_file.txt \
#     --aaf-bins 0.001,0.01,0.05,0.1 \
#     --vc-MACthr 10 \
#     --joint acat,sbat \
#     --vc-tests skato,acato-full \
#     --rgc-gene-p \
#     --out "${output_dir}/step2_gb_euro_cin3plus_chr9_no_BMS1P14"
THREADS=1 && \
  regenie \
    --step 2 \
    --pgen /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID \
    --chr 9 \
    --phenoFile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt \
    --bt \
    --covarFile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt \
    --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
    --strict \
    --bsize 5 \
    --firth --approx \
    --threads $THREADS \
    --pred /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step1/regenie_step1_euro_cin3plus_pred.list \
    --use-null-firth /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step1/regenie_step1_euro_cin3plus_firth.list \
    --anno-file /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/anno_file_unique_filtered.txt \
    --set-list "$SET_SINGLE" \
    --mask-def /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/mask_file.txt \
    --aaf-bins 0.001,0.01,0.05,0.1 \
    --vc-MACthr 10 \
    --joint acat,sbat \
    --vc-tests skato,acato-full \
    --rgc-gene-p \
    --out "${output_dir}/step2_gb_euro_cin3plus_chr9_BMS1P14_only"
conda deactivate
echo "--------done"
