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

# install.packages('lulab.utils', repos = c('https://leslie-lu.r-universe.dev', 'https://cloud.r-project.org'))
# lulab.utils::test_mirror("China")
library(magrittr)
library(data.table)
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
pheno_covar_prs = readRDS(
  file = file.path(outputDir, "CIN3plus_proteomic_pheno_covar_prs.rds")
)
MR_2SLS_results = omixVizR::MR_2SLS(
  infile = pheno_covar_prs,
  outcome = "CIN3plus",
  outcome_name = "CIN3+ (CC and CIN3)",
  prs_cols_match = "_SUM",
  regexpr_pattern = "(?<=beta_)[^_]+(?=_)",
  standardise = TRUE,
  digits = 3,
  .progress = TRUE
)
# saveRDS(MR_2SLS_results,
#         file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results.rds"))


## --- Part3 ---
# MR_2SLS_results = readRDS(
#   file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results.rds")
# )
# mr_results = MR_2SLS_results$mr_results
# data.table::setDT(mr_results)
# mr_results %>% dim()
# mr_results %>% head()
# mr_results %>% names()
# mr_results %>%
#   openxlsx::write.xlsx(
#     file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results.xlsx"),
#     sheetName = "Table S6",
#     rowNames = FALSE,
#     colWidths = "auto"
#   )
# col_name <- "Significant with a Bonferroni correction (0.05/147=3.40e-04)"
# mr_results[get(col_name) == "Yes", .N]
# mr_results[get(col_name) == "Yes", ] %>% head()
# mr_results[get(col_name) == "Yes", length(unique(Metabolite))]
