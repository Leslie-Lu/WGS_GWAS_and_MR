#!/usr/bin/env Rscript
###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p011_GWAS_power.r
# DESCRIPTION       : Power analysis for GWAS
# DATE CREATED      : 2025-05-16
# INSPIRED BY       : https://cran.r-project.org/web/packages/genpwr/vignettes/vignette.html
# OUTPUT            : output/Figure/F_001_GWAS_power.png
# R VERSION         : 4.5.1
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-07-22
# REASON            : Plot GWAS power using omixVizR package (v1.1.4)
# INSTALLTION       : install.packages('omixVizR', repos = c('https://leslie-lu.r-universe.dev', 'https://cloud.r-project.org'))
################################################################################################
rm(list = ls())
gc()

options(warn = -1)
suppressPackageStartupMessages({
  library(omixVizR)
  library(magrittr)
})
options(warn = 0)

power_results <- plot_gwas_power(
        trait_type = "bt",
        n_cases = 5578,
        n_controls = 198394,
        maf_levels = c(0.01, 0.02, 0.05, 0.10, 0.20, 0.50),
        or_range = seq(1.01, 2.00, 0.01),
        save_plot = TRUE,
        plot_title= "CIN3+ (CC and CIN3) / Controls"
    )

tempdir()
tmp_file <- file.path(tempdir(), "gwas_power_plot.png")
final_file <- "output/Figure/SF_005_GWAS_power.png"
file.copy(tmp_file, final_file, overwrite = TRUE)
file.remove(tmp_file)
