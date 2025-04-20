#!/bin/bash
###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p007_QC_european.sh
# DESCRIPTION       : QC for European ancestry individuals on DNAnexus platform and/or local
# DATE CREATED      : 2025-04-18
# INSPIRED BY       : https://documentation.dnanexus.com/user/helpstrings-of-sdk-command-line-utilities#run
#                   : https://documentation.dnanexus.com/user/running-apps-and-workflows/running-apps-and-applets
#                   : https://platform.dnanexus.com/app/swiss-army-knife
#                   : https://cloufield.github.io/GWASTutorial/04_Data_QC/#plink-syntax
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-04-18
# REASON            : Initial version
################################################################################################

# # 1. keep only European ancestry individuals on local
# # merge all snp microarray data (ssh)
# threads=$(nproc)
# plink --make-bed \
#   --merge-list /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/chr_merge_list_sorted2.txt \
#   --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/merged_snp_microarray \
#   --threads $threads
# # keep only European ancestry individuals (ssh)
# threads=$(nproc)
# plink --make-bed \
#   --bfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/merged_snp_microarray \
#   --keep /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/D007EligibleCasesandControlsID_european.txt \
#   --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/snp_microarray_european \
#   --threads $threads

# 2. QC for European ancestry individuals on local
threads=$(nproc)
genotypeFile="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/snp_microarray_european"
output_path="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/QC_european"
# # Missing rate (call rate)
# plink \
#   --bfile ${genotypeFile} \
#   --missing \
#   --threads $threads \
#   --out "$output_path/plink_results_missing_rate"
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p008_genotype_data_qc.ipynb
# # Allele frequency
# plink \
#   --bfile ${genotypeFile} \
#   --freq \
#   --out "$output_path/plink_result_allele_freq" \
#   --threads $threads
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p008_genotype_data_qc.ipynb
# # Hardy-Weinberg equilibrium exact test
# plink \
#   --bfile ${genotypeFile} \
#   --hardy \
#   --out "$output_path/plink_result_hwe" \
#   --threads $threads
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p008_genotype_data_qc.ipynb

# LD pruning
plink \
  --bfile ${genotypeFile} \
  --maf 0.001 \
  --geno 0.05 \
  --mind 0.05 \
  --hwe 1e-6 \
  --indep-pairwise 50 5 0.2 \
  --out "$output_path/plink_result_ld_pruning" \
  --threads $threads
