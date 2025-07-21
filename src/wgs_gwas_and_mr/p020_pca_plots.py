#!/usr/bin/env python3
###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p020_plot_pca.py
# DESCRIPTION       : Plot PCA results
# DATE CREATED      : 2025-07-15
# PYTHON VERSION    : 3.12.10
################################################################################################
# DATE MODIFIED     : 2025-07-15
# REASON            : Initial version
################################################################################################

import sys
sys.path.append("/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/")
from p020_plot_pca import plot_pca_plots

plot_pca_plots(
    eigenvec_file="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european/backup_20250715/smartpca_outcome_cc_cin3/euro_cc_cin3_fig.eigenvec",
    country_file="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european/D009_GWAS_CIN3Plus_European.csv",
    fig_path="/share/home/lsy_luzhen/WGS_GWAS_and_MR/output/Figure/",
    fig1_name="SF007_pairPlotofPCA",
    fig2_name="SF008_scatterPlotofPCA",
    save_figs=True
)