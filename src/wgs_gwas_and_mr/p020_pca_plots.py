#!/usr/bin/env python3
###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p020_plot_pca.py
# DESCRIPTION       : Plot PCA results
# DATE CREATED      : 2025-07-15
# PYTHON VERSION    : 3.12.10
################################################################################################
# DATE MODIFIED     : 2025-07-30
# REASON            : Ploting PCA results using the package omixvizpy
################################################################################################

from omixvizpy import plot_pca

plot_pca(
    eigenvec_file="path/to/your/eigenvec.txt",
    covar_file="path/to/your/covariates.csv",
    cov1="Country_of_birth",
    legend_title_cov1="Country of Birth",
    cov1_levels=["England", "Wales", "Scotland", "Others"],
    fig_path="output/directory",
    fig1_name="variance_explained",
    fig2_name="pc1_vs_pc2", 
    fig3_name="pca_by_country",
    fig4_name="pca_by_ethnicity",
    save_figs=True
)
