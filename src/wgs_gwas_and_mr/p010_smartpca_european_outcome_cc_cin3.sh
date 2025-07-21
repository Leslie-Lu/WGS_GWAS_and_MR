#!/bin/bash
###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p010_smartpca_european_outcome_cc_cin3.sh
# DESCRIPTION       : Inplement smartpca for outcome CC and CIN3
# DATE CREATED      : 2025-04-22
# INPUT             : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p010_smartpca_outcome_cc_cin3.par
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-07-15
# REASON            : Debug and rerun PCA
################################################################################################

# smartpca on local
source /share/home/lsy_luzhen/software/miniconda3/bin/activate eigensoft
echo "--------start"
echo "Print the version of eigensoft..."
smartpca -v
echo "Begining PCA..."
smartpca -p \
  /share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p010_smartpca_european_outcome_cc_cin3.par \
  > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european/smartpca_outcome_cc_cin3/euro_cc_cin3.log
conda deactivate
echo "--------done"
