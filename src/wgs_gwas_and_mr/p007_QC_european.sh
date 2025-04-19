#!/bin/bash
###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p007_QC_european.sh
# DESCRIPTION       : QC for European ancestry individuals on DNAnexus platform and/or local
# DATE CREATED      : 2025-04-18
# INSPIRED BY       : https://documentation.dnanexus.com/user/helpstrings-of-sdk-command-line-utilities#run
#                   : https://documentation.dnanexus.com/user/running-apps-and-workflows/running-apps-and-applets
#                   : https://platform.dnanexus.com/app/swiss-army-knife
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
