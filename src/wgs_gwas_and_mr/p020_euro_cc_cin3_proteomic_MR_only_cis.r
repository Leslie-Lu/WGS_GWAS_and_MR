###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p020_euro_cc_cin3_proteomic_MR_only_cis.r
# DESCRIPTION       : Perform Mendelian Randomization (MR) analysis using proteomic data
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
# install.packages("pheatmap")
# if(!requireNamespace("omixVizR", quietly = TRUE)) {
#   install.packages("omixVizR", repos = c('https://leslie-lu.r-universe.dev'))
# }
# packageVersion("omixVizR")

# outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis"
outputDir = "C:/luzh29/Library/Projects/WGS_GWAS_and_MR/data/input"

## --- Part1 ---
# phenoFile = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt"
# covarFile = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt"
# pheno = data.table::fread(phenoFile)
# covar = data.table::fread(covarFile)

# catCovarList = c(
#     "Smoking_status","Alcohol_intake_frequency","Genotype_measurement_batch"
# )
# purrr::map(catCovarList, ~ table(covar[[.x]], useNA = "always"))
# covar[, (catCovarList) := lapply(.SD, as.factor), .SDcols = catCovarList]
# purrr::map(catCovarList, ~ levels(covar[[.x]]))

# # Merge pheno and covar
# pheno_covar = pheno[covar, on = c("FID", "IID")]

# prs_data = data.table::fread(
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/Euro_MR_proteomic_PRS_only_cis.sscore",
#   header = TRUE
# )
# data.table::setnames(prs_data, c("#IID"), c("IID"))

# pheno_covar_prs = pheno_covar[prs_data, on = "IID"][, `:=`(FID = NULL, IID = NULL)]
# saveRDS(pheno_covar_prs,
#         file = file.path(outputDir, "CIN3plus_proteomic_pheno_covar_prs_only_cis.rds"))


## --- Part2 ---
# pheno_covar_prs = readRDS(
#   file = file.path(outputDir, "CIN3plus_proteomic_pheno_covar_prs_only_cis.rds")
# )
# pheno_covar_prs %>% dim()
# pheno_covar_prs %>% names()
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
#         file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results_only_cis.rds"))


## --- Part3 ---
# scp -i C:/Users/luzh2/.ssh/id_rsa -P 9022 \
#   lsy_luzhen@172.25.48.192:/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/CIN3plus_proteomic_MR_2SLS_results_only_cis.rds \
#   "C:\luzh29\Library\Projects\WGS_GWAS_and_MR\data\input"

MR_2SLS_results = readRDS(
  file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results_only_cis.rds")
)
mr_results = MR_2SLS_results$mr_results
data.table::setDT(mr_results)
mr_results %>% dim()
mr_results %>% head()

# annotation
protein_ids_final = data.table::fread(
  file.path(outputDir, "pqlts_only_cis_20251020_protein_assay_rsID.txt")
)
protein_ids_final %>% dim()
protein_ids_final %>% head()
protein_ids_final[, Raw_Metabolite := paste0(UKBPPP.ProteinID.new.v2, "_SUM") %>% gsub("-", "_", ., fixed = TRUE)]
protein_ids_final$Raw_Metabolite %>% head()
protein_ids_final[Raw_Metabolite == "beta_SSNA1_O43805_OID31453_v1_rs535590282_SUM",]
mr_results_new = protein_ids_final[, .(Raw_Metabolite, Assay.Target)][mr_results, on = c("Raw_Metabolite" = "Raw_Metabolite"), nomatch = 0]
mr_results %>% dim()
mr_results_new %>% dim()
mr_results_new %>% names()
mr_results_new[, `:=`(
  Raw_Metabolite = NULL,
  Metabolite = NULL
)]
data.table::setnames(mr_results_new, "Assay.Target", "Metabolite")

mr_results_new %>% names()
protein_ids_final %>% names
mr_results_new2 = protein_ids_final[, .(
  Raw_Metabolite, SNP_new_v2, CHROM, `GENPOS.(hg38)`, Region.ID, Region.Start, Region.End, UKBPPP.ProteinID, Assay.Target, Target.UniProt, rsID,
  A0_new_v2, A1_new_v2, `cis/trans`, cis.gene, Bioinfomatic.annotated.gene, Ensembl.gene.ID, Annotated.gene.consequence,
  Biotype, Distance.to.gene, CADD_phred, SIFT, PolyPhen, PHAST.Phylop_score, FitCons_score, IMPACT
)][mr_results, on = c("Raw_Metabolite" = "Raw_Metabolite"), nomatch = 0]
mr_results %>% dim()
mr_results_new2 %>% dim()
mr_results_new2 %>% names()
mr_results_new2[, `:=`(
  Raw_Metabolite = NULL,
  Metabolite = NULL
)]
data.table::setnames(mr_results_new2,
  c("SNP_new_v2", "CHROM", "GENPOS.(hg38)", "Region.ID", "Region.Start", "Region.End", "UKBPPP.ProteinID", "Assay.Target", "Target.UniProt", "rsID",
    "A0_new_v2", "A1_new_v2", "cis/trans", "cis.gene", "Bioinfomatic.annotated.gene", "Ensembl.gene.ID", "Annotated.gene.consequence",
    "Biotype", "Distance.to.gene", "CADD_phred", "SIFT", "PolyPhen", "PHAST.Phylop_score", "FitCons_score", "IMPACT"), 
  c("Variant ID (CHROM:GENPOS (hg38):A0:A1)", "CHROM", "GENPOS (hg38)", "Region ID", "Region Start", "Region End",
    "UKBPPP ProteinID", "Assay Target", "Target UniProt", "rsID", "A0", "A1", "cis/trans", "cis gene", "Bioinformatic annotated gene",
    "Ensembl gene ID", "Annotated gene consequence", "Biotype", "Distance to gene", "CADD_phred", "SIFT", "PolyPhen", "PHAST Phylop_score",
    "FitCons_score", "IMPACT"))
mr_results_new2 %>%
  openxlsx::write.xlsx(
    file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results_only_cis.xlsx"),
    sheetName = "Table S7",
    rowNames = FALSE,
    colWidths = "auto"
  )
mr_results_new %>% dim()
mr_results_new %>% names()
col_name = names(mr_results_new)[stringr::str_detect(names(mr_results_new), "Bonferroni")]
# col_name <- "Significant with a Bonferroni correction (0.05/1701=2.94e-05)"
mr_results_new[get(col_name) == "Yes", .N]
mr_results_new[get(col_name) == "Yes", ] %>% head()
mr_results_new[get(col_name) == "Yes", length(unique(Metabolite))]

sig_metabolites = mr_results_new[get(col_name) == "Yes", ]
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

# p_right_data = sig_metabolites[, .(`Odds ratio (95% CI)`, `P value`, `Significant with a Bonferroni correction (0.05/1701=2.94e-05)`)]
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
                                       output_path = "C:/luzh29/Library/Projects/WGS_GWAS_and_MR/output/Figure",
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


## --- Part4 ---
# MR_2SLS_results = readRDS(
#   file = file.path(outputDir, "CIN3plus_proteomic_MR_2SLS_results_only_cis.rds")
# )
cor_mat = MR_2SLS_results$correlation_matrix

cor_mat %>% str()
new_colnames = purrr::map_chr(colnames(cor_mat), ~ stringr::str_extract(.x, "(?<=beta_)[^_]+(?=_)"))
new_rownames = purrr::map_chr(rownames(cor_mat), ~ stringr::str_extract(.x, "(?<=beta_)[^_]+(?=_)"))
colnames(cor_mat) = new_colnames
rownames(cor_mat) = new_rownames

omixVizR::plot_heatmap(cor_mat)
