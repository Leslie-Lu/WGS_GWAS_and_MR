###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p020_euro_cc_cin3_proteomic_MR.r
# DESCRIPTION       : Perform Mendelian Randomization (MR) analysis using proteomic data
# DATE CREATED      : 2025-10-03
# INPUT             : 
# OUTPUT            : 
# R VERSION         : 4.4.3
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-10-03
# REASON            : Initial file creation
################################################################################################
rm(list = ls())
gc()

# remove.packages("lulab.utils")
# install.packages('lulab.utils', repos = c('https://leslie-lu.r-universe.dev', 'https://cloud.r-project.org'))
# packageVersion("lulab.utils")
lulab.utils::test_mirror("China")
options(repos = c(CRAN = 'https://mirrors.sustech.edu.cn/CRAN/'))
library(magrittr)
library(data.table)
# remove.packages("omixVizR")
# if(!requireNamespace("omixVizR", quietly = TRUE)) {
#   install.packages("omixVizR", repos = c('https://leslie-lu.r-universe.dev'))
# }

outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic"

## --- Part1 ---
# phenoFile = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt"
# covarFile = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt"
# pheno = data.table::fread(phenoFile)
# covar = data.table::fread(covarFile)

# catCovarList = c(
#     "Smoking_status","Alcohol_intake_frequency","Genotype_measurement_batch"
# )
# # purrr::map(catCovarList, ~ table(covar[[.x]], useNA = "always"))
# covar[, (catCovarList) := lapply(.SD, as.factor), .SDcols = catCovarList]
# # purrr::map(catCovarList, ~ levels(covar[[.x]]))

# # Merge pheno and covar
# pheno_covar = pheno[covar, on = c("FID", "IID")]

# prs_data = data.table::fread(
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic/Euro_MR_proteomic_PRS.sscore",
#   header = TRUE
# )
# data.table::setnames(prs_data, c("#IID"), c("IID"))

# pheno_covar_prs = pheno_covar[prs_data, on = "IID"][, `:=`(FID = NULL, IID = NULL)]
# saveRDS(pheno_covar_prs,
#         file = file.path(outputDir, "CIN3plus_proteomic_pheno_covar_prs.rds"))


## --- Part2 ---
# pheno_covar_prs = readRDS(
#   file = file.path(outputDir, "CIN3plus_proteomic_pheno_covar_prs.rds")
# )
# MR_2SLS_results = omixVizR::MR_2SLS(
#   infile = pheno_covar_prs,
#   outcome = "CIN3plus",
#   outcome_name = "CIN3+ (CC and CIN3)",
#   prs_cols_match = "_SUM",
#   regexpr_pattern = "(?<=beta_)[^_]+(?=_)",
#   standardise = TRUE,
#   digits = 3,
#   .progress = TRUE
# )
# saveRDS(MR_2SLS_results,
#         file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results.rds"))


## --- Part3 ---
MR_2SLS_results = readRDS(
  file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results.rds")
)
mr_results = MR_2SLS_results$mr_results
data.table::setDT(mr_results)
mr_results %>% dim()
mr_results %>% head()
mr_results %>% names()
# mr_results %>%
#   openxlsx::write.xlsx(
#     file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results.xlsx"),
#     sheetName = "Table S6",
#     rowNames = FALSE,
#     colWidths = "auto"
#   )
col_name <- "Significant with a Bonferroni correction (0.05/147=3.40e-04)"
mr_results[get(col_name) == "Yes", .N]
mr_results[get(col_name) == "Yes", ] %>% head()
mr_results[get(col_name) == "Yes", length(unique(Metabolite))]

sig_metabolites = mr_results[get(col_name) == "Yes", ]
sig_metabolites %>% dim()
sig_metabolites %>% str()
sig_metabolites[, `:=`(
  `Raw P value` = as.numeric(`Raw P value`),
  OR = as.numeric(OR),
  OR.confint.lower = as.numeric(OR.confint.lower),
  OR.confint.upper = as.numeric(OR.confint.upper)
)]
data.table::setorder(sig_metabolites, -OR)
sig_metabolites %>% head()


# p_left_data = sig_metabolites[, .(Metabolite, `Sample size`, Cases, Controls)]
p_left_data = sig_metabolites[, .(Metabolite)]
p_left_data %>% head()

p_right_data = sig_metabolites[, .(`Odds ratio (95% CI)`, `P value`, `Significant with a Bonferroni correction (0.05/147=3.40e-04)`)]
p_right_data %>% head()

min(sig_metabolites$OR.confint.lower)
max(sig_metabolites$OR.confint.upper)
mr_forest_plot = omixVizR::plot_forest(p_left_data = p_left_data,
                                       point_estimate = sig_metabolites$OR,
                                       ci_lower_bound = sig_metabolites$OR.confint.lower,
                                       ci_upper_bound = sig_metabolites$OR.confint.upper,
                                       ci_sep = ", ",
                                       p_right_data = p_right_data,
                                       precision_digits = 3,
                                       p_mid_width = 45,
                                       null_line_at = 1,
                                       output_path = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic",
                                       dpi = 600,
                                       display = TRUE,
                                       font_family = c("MetroSans"),
                                       p_left_data_name = c('Metabolite'),
                                       p_right_data_name = c("Adjusted odds ratio (95% CI)", "P", "Bonferroni significance"),
                                       stripe_colour = "#eff3f2",
                                       background_colour = "white",
                                       x_scale_linear = TRUE,
                                       xlim = c(0.8, 1.2),
                                       xbreaks = c(0.8, 0.9, 1.0, 1.1, 1.2),
                                       nudge_y = -0.5,
                                       nudge_x = 1,
                                       nudge_height = 0,
                                       nudge_width = 0,
                                       justify = c(0, 0.5, 0.5, 0.5),
                                       arrows = TRUE,
                                       arrow_labels = c("Lower risk", "Higher risk"),
                                       risk_colors = c("#E52B25", "#2981B3"),
                                       arrow_nudge_y = 0.2,
                                       add_plot = NULL,
                                       add_plot_width = 1,
                                       add_plot_gap = FALSE,
                                       point_sizes = 2.5,
                                       point_shapes = 15,
                                       p_mid_forest = NULL,
                                       lower_header_row = FALSE,
                                       render_as = "png",
                                       table_theme = NULL)
