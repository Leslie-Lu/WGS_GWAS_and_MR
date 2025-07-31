#!/usr/bin/env python3
###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p020_plot_pca.py
# DESCRIPTION       : Plot PCA results
# DATE CREATED      : 2025-07-15
# PYTHON VERSION    : 3.13.5
################################################################################################
# DATE MODIFIED     : 2025-07-30
# REASON            : Ploting PCA results using the package omixvizpy v0.1.2
################################################################################################

from omixvizpy import plot_pca

plot_pca(
    eigenvec_file="./data/output/euro_cc_cin3.eigenvec",
    covar_file="./data/output/D009_GWAS_CIN3Plus_European.csv",
    cov1="Country_of_birth",
    legend_title_cov1="Country of Birth",
    cov1_levels=["England", "Wales", "Scotland", "Others"],
    fig_path="./output/Figure",
    fig1_name="FigS7_variance_explained",
    fig2_name="FigS8_Scatter_plot_of_PC1_vs_PC2_colored_and_shaped_by_Country_of_birth", 
    fig3_name="FigS9_Scatter_plot_of_PC1-5_colored_and_shaped_by_Country_of_birth",
    save_figs=True
)
