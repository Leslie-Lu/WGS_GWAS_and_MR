###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p019_euro_cc_cin3_metabolic_MR.r
# DESCRIPTION       : Perform Mendelian Randomization (MR) analysis using metabolic data
# DATE CREATED      : 2025-10-15
# INPUT             : 
# OUTPUT            : 
# R VERSION         : 4.4.3
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-10-15
# REASON            : Initial file creation
################################################################################################
rm(list = ls())
gc()

# remove.packages("lulab.utils")
# install.packages('lulab.utils', repos = c('https://leslie-lu.r-universe.dev', 'https://cloud.r-project.org'))
# packageVersion("lulab.utils")
# lulab.utils::test_mirror("China")
# options(repos = c(CRAN = 'https://mirrors.sustech.edu.cn/CRAN/'))
library(magrittr)
library(data.table)
# remove.packages("omixVizR")
# # install.packages("pheatmap")
# if(!requireNamespace("omixVizR", quietly = TRUE)) {
#   install.packages("omixVizR", repos = c('https://leslie-lu.r-universe.dev'))
# }
# packageVersion("omixVizR")

# ## --- 1. run on the server ---
# outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/metabolic"
# ## --- Part1 ---
# inDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/NMR"
# MR_samples_protein = readRDS(
#   file = file.path(inDir, "CIN3plus_metabolite_MR_samples_phenos.rds")
# )
# message("Dimensions of MR samples with metabolic data: ", dim(MR_samples_protein)[1], " x ", dim(MR_samples_protein)[2])
# message("Head of MR samples with metabolic data:")
# print(head(MR_samples_protein))
# message("Names of MR samples with metabolic data:")
# print(names(MR_samples_protein))
# prs_data = data.table::fread(
#   file = file.path(outputDir, "Euro_MR_metabolic_PRS.sscore"),
#   header = TRUE
# )
# data.table::setnames(prs_data, c("#IID"), c("eid"))
# message("Dimensions of PRS data: ", dim(prs_data)[1], " x ", dim(prs_data)[2])
# pheno_covar_prs = MR_samples_protein[prs_data, on = "eid"][, `:=`(eid = NULL)]
# message("Dimensions of phenotype, covariate and PRS combined data: ", dim(pheno_covar_prs)[1], " x ", dim(pheno_covar_prs)[2])
# saveRDS(pheno_covar_prs,
#         file = file.path(outputDir, "CIN3plus_metabolic_pheno_covar_prs.rds"))
# proteins_corr_data = readRDS(
#   file = file.path(inDir, "CIN3plus_metabolites_corr_full_data.rds")
# )
# # protein_ids_final = data.table::fread(
# #   file.path(outputDir, "pqlts_20251104_metabolite_assay_rsID.txt")
# # )
# # message("Dimensions of protein IDs final data: ", dim(protein_ids_final)[1], " x ", dim(protein_ids_final)[2])
# # data.table::uniqueN(protein_ids_final, by = "Assay.Target_lower")
# # data.table::uniqueN(protein_ids_final, by = "UKBPPP.ProteinID.new.v2")
# # proteins_subset = protein_ids_final$Assay.Target_lower %>% unique() %>%
# #   gsub("-", "_", ., fixed = TRUE)
# message("Dimensions of metabolic correlation data: ", dim(proteins_corr_data)[1], " x ", dim(proteins_corr_data)[2])
# proteins_corr_data %>%
#   dplyr::select(dplyr::contains("hla") | dplyr::contains(".")) %>%
#   names()
# message("Head 30 names of metabolic correlation data:")
# print(head(names(proteins_corr_data), 30))
# message("Tail 30 names of metabolic correlation data:")
# print(tail(names(proteins_corr_data), 30))
# old_col_names = names(MR_samples_protein)
# message("Old column names to match PRS data:")
# print(old_col_names)
# new_col_names = gsub("-", "_", old_col_names, fixed = TRUE)
# # proteins_corr_subset = proteins_corr_data[, .SD, .SDcols = c(new_col_names, proteins_subset)]
# proteins_corr_subset = proteins_corr_data
# message("Dimensions of metabolic correlation subset data: ", dim(proteins_corr_subset)[1], " x ", dim(proteins_corr_subset)[2])
# data.table::setnames(proteins_corr_subset, "3_Hydroxybutyrate", "X3_Hydroxybutyrate")
# proteins_measured = setdiff(names(proteins_corr_subset), new_col_names)
# message("Number of proteins measured: ", length(proteins_measured))
# proteins_corr_subset[, eid := NULL]


# ## --- Part2 ---
# message("Starting MR 2SLS analysis...")
# MR_2SLS_results = omixVizR::MR_2SLS(
#   infile = pheno_covar_prs,
#   proteins_data = proteins_corr_subset,
#   proteins_measured = proteins_measured,
#   outcome = "CIN3plus",
#   outcome_name = "CIN3+ (CC and CIN3)",
#   prs_cols_match = "_SUM",
#   regexpr_pattern = "(?<=beta_)[^_]+(?=_)",
#   standardise = TRUE,
#   digits = 3,
#   .progress = TRUE
# )
# saveRDS(MR_2SLS_results,
#         file = file.path(outputDir, "CIN3plus_metabolic_MR_2SLS_results.rds"))


## --- 2. run locally ---
outputDir = "./data/input"
## --- Part3 ---
MR_2SLS_results = readRDS(
  file = file.path(outputDir, "CIN3plus_metabolic_MR_2SLS_results.rds")
)
mr_results = MR_2SLS_results$mr_results
data.table::setDT(mr_results)
mr_results %>% dim()
mr_results %>% head()
# annotate the results
protein_ids_final = data.table::fread(
  file.path(outputDir, "pqlts_20251104_metabolite_assay_rsID.txt")
)
protein_ids_final %>% dim()
protein_ids_final %>% head()
protein_ids_final[, Raw_Metabolite := paste0(UKBB_phenotype_name_new_v2, "_SUM") %>% gsub("-", "_", ., fixed = TRUE)]
protein_ids_final$Raw_Metabolite %>% head()
protein_ids_final[Raw_Metabolite == "beta_SSNA1_O43805_OID31453_v1_rs535590282_SUM", ]
data.table::uniqueN(protein_ids_final, by = "Raw_Metabolite")
data.table::uniqueN(mr_results, by = "Raw_Metabolite")
protein_ids_final %>% names()
protein_ids_final %>% head()

protein_ids_final[, unique(Metabolite)]
mr_results[, unique(Metabolite)]

mr_results_new = protein_ids_final[, .(
  Raw_Metabolite, SNP_new_v2, CHR, end_hg38, Metabolite, Region_ID, UKBB_phenotype_name_new, rsID,
  A0_new_v2, A1_new_v2
)][mr_results, on = c("Raw_Metabolite" = "Raw_Metabolite"), nomatch = 0]
mr_results %>% dim()
mr_results_new %>% dim()
mr_results_new %>% names()
mr_results_new %>% head
mr_results_new[, `:=`(
  Raw_Metabolite = NULL,
  i.Metabolite = NULL
)]
data.table::setnames(mr_results_new,
  c("SNP_new_v2", "CHR", "end_hg38", "Region_ID", "Metabolite", "UKBB_phenotype_name_new", "rsID",
    "A0_new_v2", "A1_new_v2"), 
  c("Variant ID (CHROM:GENPOS (hg38):A0:A1)", "CHROM", "GENPOS (hg38)", "Region ID", "Metabolite", "UKBB_phenotype_name",
  "rsID", "A0", "A1"))
mr_results_new %>%
  openxlsx::write.xlsx(
    file = file.path(outputDir, "CIN3plus_metabolic_MR_2SLS_results.xlsx"),
    sheetName = "Table S7",
    rowNames = FALSE,
    colWidths = "auto"
  )
mr_results_new %>% dim()
mr_results_new %>% names()
col_name = names(mr_results_new)[stringr::str_detect(names(mr_results_new), "Bonferroni")]
mr_results_new[get(col_name) == "Yes", .N]
mr_results_new[get(col_name) == "Yes", ] %>% head()
mr_results_new[get(col_name) == "Yes", length(unique(`UKBB_phenotype_name`))]

sig_metabolites = mr_results_new[get(col_name) == "Yes", ]
sig_metabolites %>% dim()
cols_subset = c("Metabolite", "Sample size", "OR", "OR.confint.lower", "OR.confint.upper", "Odds ratio (95% CI)", col_name, "P value", "Raw P value")
sig_metabolites = sig_metabolites[, .SD, .SDcols = cols_subset] %>% unique()
sig_metabolites %>% dim()
# sig_metabolites[, .(`Variant ID (CHROM:GENPOS (hg38):A0:A1)`)] %>%
#   data.table::fwrite(
#     "./output/p020_cumu_risk_metabolic_ivs.txt",
#     col.names = FALSE
#   )
sig_metabolites %>% str()
sig_metabolites[, `:=`(
  `Raw P value` = as.numeric(`Raw P value`),
  OR = as.numeric(OR),
  OR.confint.lower = as.numeric(OR.confint.lower),
  OR.confint.upper = as.numeric(OR.confint.upper)
)]
data.table::setorder(sig_metabolites, -OR)
sig_metabolites %>% head()
# p_left_data = sig_metabolites[, .(`UKBB_phenotype_name`, `Sample size`, Cases, Controls)]
p_left_data = sig_metabolites[, .(Metabolite, `Sample size`)]
p_left_data %>% head()
p_left_data[, `Sample size` := formatC(as.numeric(`Sample size`), format = "d", big.mark = ",")]
cols_to_select <- c("Odds ratio (95% CI)", "P value", col_name)
p_right_data = sig_metabolites[, .SD, .SDcols = cols_to_select]
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
                                       output_path = "./output/Figure",
                                       dpi = 600,
                                       display = TRUE,
                                       font_family = c("MetroSans"),
                                       p_left_data_name = c('Metabolites', 'Sample size'),
                                       p_right_data_name = c("Adjusted odds ratio (95% CI)", "P", "Bonferroni significance"),
                                       stripe_colour = "#eff3f2",
                                       background_colour = "white",
                                       x_scale_linear = TRUE,
                                       xlim = c(0.8, 1.2),
                                       xbreaks = c(0.8, 0.9, 1.0, 1.1, 1.2),
                                       nudge_y = 0,
                                       nudge_x = 1,
                                       nudge_height = 0,
                                       nudge_width = 0,
                                       justify = c(0, 0.5, 0.5, 0.5, 0.5),
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

## --- Part4 ---
cor_mat = MR_2SLS_results$correlation_matrix
cor_mat %>% str()
new_colnames = purrr::map_chr(colnames(cor_mat), ~ stringr::str_to_upper(.x))
new_rownames = purrr::map_chr(rownames(cor_mat), ~ stringr::str_to_upper(.x))
colnames(cor_mat) = new_colnames
rownames(cor_mat) = new_rownames
omixVizR::plot_heatmap(cor_mat)
