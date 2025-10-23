###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p030_identify_samples_for_mr.r
# DESCRIPTION       : To identify samples for Mendelian Randomization.
# DATE CREATED      : 2025-06-11
# INPUT             : 
# OUTPUT            : 
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-07-01
# REASON            : Confirm the logic of selecting samples for MR analysis
################################################################################################
# DATE MODIFIED     : 2025-09-29
# REASON            : Reconfirm the code and debug
################################################################################################
rm(list = ls())
gc()

# lulab.utils::test_mirror("China")
# options(repos = c(CRAN = 'https://mirrors.ustc.edu.cn/CRAN/'))
# install.packages("data.table")
# library(lulab.utils)
library(magrittr)
# library(dplyr)
# library(data.table)
# library(purrr)

# ## --- Part 1: tidy proteins data ---
# inPath = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/olink_proteins"
# for (i in c(0, 2, 3)){
#   assign(paste0("olink_proteins_", i),
#     data.table::fread(
#       file.path(inPath, paste0("instance_", i, "_df_wide.csv")),
#       header = TRUE
#     )
#   )
# }
# for (i in c(0, 2, 3)){
#   data.table::setDT(get(paste0("olink_proteins_", i)))
#   get(paste0("olink_proteins_", i))[, ins_index := i]
#   assign(paste0("instance_", i, "_df_long"),
#     data.table::melt(
#       get(paste0("olink_proteins_", i)),
#       id.vars = c("eid", "ins_index"),
#       variable.name = "protein_id",
#       value.name = "result"
#     ) %>% na.omit()
#   )
# }
# for (i in c(0, 2, 3)){
#   print(dim(get(paste0("instance_", i, "_df_long"))))
# }

# olink_df = data.table::rbindlist(
#   list(
#     instance_0_df_long,
#     instance_2_df_long,
#     instance_3_df_long
#   ),
#   use.names = TRUE,
#   fill = FALSE
# )

# # load coding
# coding143 = data.table::fread(
#   file.path(inPath, "coding143.tsv"),
#   header = TRUE
# )
# coding143[, meaning := stringr::str_to_lower(stringr::str_replace(meaning, ";.*", "") %>% stringr::str_replace_all("-", "_"))]
# # field 30900
# field_30900_df = data.table::fread(
#   file.path(inPath, "field_30900.csv"),
#   header = TRUE
# )
# field_30900_df[, participant.p30900_i1 := NULL]
# field_30900_df_long = field_30900_df %>% data.table::melt(
#   id.vars = c("participant.eid"),
#   variable.name = "raw_instance",
#   value.name = "N_proteins"
# )
# field_30900_df_long[, instance := as.character(raw_instance) %>% stringr::str_remove_all("participant.p30900_i") %>% as.integer()][
#   , raw_instance := NULL
# ]
# field_30900_df_tidy <- field_30900_df_long[!is.na(N_proteins),]
# # filed 30901
# field_30901_df = data.table::fread(
#   file.path(inPath, "field_30901.csv"),
#   header = TRUE
# )
# field_30901_df[, participant.p30901_i1 := NULL]
# field_30901_df_long = field_30901_df %>% data.table::melt(
#   id.vars = c("participant.eid"),
#   variable.name = "raw_instance",
#   value.name = "PlateID"
# )
# field_30901_df_long[, instance := as.character(raw_instance) %>% stringr::str_remove_all("participant.p30901_i") %>% as.integer()][
#   , raw_instance := NULL
# ][, PlateID := as.double(PlateID)]
# field_30901_df_tidy <- field_30901_df_long[!is.na(PlateID),]
# # field 30902
# field_30902_df = data.table::fread(
#   file.path(inPath, "field_30902.csv"),
#   header = TRUE
# )
# field_30902_df[, participant.p30902_i1 := NULL]
# field_30902_df_long = field_30902_df %>% data.table::melt(
#   id.vars = c("participant.eid"),
#   variable.name = "raw_instance",
#   value.name = "WellID"
# )
# field_30902_df_long[, instance := as.character(raw_instance) %>% stringr::str_remove_all("participant.p30902_i") %>% as.integer()][
#   , raw_instance := NULL
# ]
# field_30902_df_tidy = field_30902_df_long[WellID != "",]
# # Assay
# olink_assay = data.table::fread(
#   file.path(inPath, "olink_assay.dat"),
#   header = TRUE
# )
# olink_assay[, Assay := stringr::str_to_lower(Assay)]
# # Assay version
# olink_assay_version = data.table::fread(
#   file.path(inPath, "olink_assay_version.dat"),
#   header = TRUE
# )
# olink_assay_version[, Assay := stringr::str_to_lower(Assay)]
# # Batch number
# olink_batch_number = data.table::fread(
#   file.path(inPath, "olink_batch_number.dat"),
#   header = TRUE
# )
# olink_batch_number[, PlateID := as.double(PlateID)]
# # Limit of detection
# olink_limit_of_detection = data.table::fread(
#   file.path(inPath, "olink_limit_of_detection.dat"),
#   header = TRUE
# )
# olink_limit_of_detection[
#   , `:=`(
#     Assay = stringr::str_to_lower(Assay),
#     PlateID = as.double(PlateID)
#   )
# ]
# # Panel lot number
# olink_panel_lot_number = data.table::fread(
#   file.path(inPath, "olink_panel_lot_number.dat"),
#   header = TRUE
# )
# # Processing start date
# olink_processing_start_date = data.table::fread(
#   file.path(inPath, "olink_processing_start_date.dat"),
#   header = TRUE
# )
# olink_processing_start_date[, PlateID := as.double(PlateID)]

# # join data
# data.table::setnames(field_30900_df_tidy, c("participant.eid", "instance"), c("eid", "ins_index"))
# data.table::setnames(field_30901_df_tidy, c("participant.eid", "instance"), c("eid", "ins_index"))
# data.table::setnames(field_30902_df_tidy, c("participant.eid", "instance"), c("eid", "ins_index"))
# data.table::setnames(coding143, "meaning", "protein_id")
# data.table::setnames(olink_limit_of_detection, c("Assay", "Instance"), c("protein_id", "ins_index"))
# data.table::setnames(olink_assay, "Assay", "protein_id")
# data.table::setnames(olink_assay_version, "Assay", "protein_id")
# olink_full_dataset = olink_df[, protein_id := as.character(protein_id)] %>%
#   {field_30900_df_tidy[., on = .(eid, ins_index)]} %>%
#   {field_30901_df_tidy[., on = .(eid, ins_index)]} %>%
#   {field_30902_df_tidy[., on = .(eid, ins_index)]} %>%
#   {coding143[., on = .(protein_id)]} %>%
#   {olink_limit_of_detection[., on = .(protein_id, ins_index, PlateID)]} %>%
#   {olink_assay[., on = .(protein_id)]} %>%
#   {olink_processing_start_date[., on = .(PlateID, Panel)]} %>%
#   {olink_batch_number[., on = .(PlateID)]} %>%
#   {olink_panel_lot_number[., on = .(Batch, Panel)]} %>%
#   {olink_assay_version[., on = .(Panel_Lot_Nr, protein_id)]}
# olink_full_dataset %>% dim()
# olink_full_dataset[ins_index == 0, data.table::uniqueN(eid), by = .(ins_index)]
# olink_full_dataset %>%
#   data.table::fwrite(
#     file.path(inPath, "olink_full_dataset.csv"),
#     col.names = TRUE,
#     row.names = FALSE,
#     sep = ","
#   )
# cols = names(olink_full_dataset)
# names(cols) = cols
# cols_to_select = cols[c('eid', 'ins_index', 'protein_id', 'result', 'N_proteins', 'coding', 'UniProt', "Panel")]
# length(cols_to_select)
# olink_subset = olink_full_dataset[ins_index == 0, ..cols_to_select]
# olink_subset %>% dim()
# olink_subset[, data.table::uniqueN(eid), by = .(ins_index)]
# olink_subset %>%
#   data.table::fwrite(
#     file.path(inPath, "olink_subset_instance0.csv"),
#     col.names = TRUE,
#     row.names = FALSE,
#     sep = ","
#   )
# # protein olink data
# data.table::uniqueN(olink_subset, "protein_id") # 2923
# data.table::uniqueN(olink_subset, "coding") # 2923
# data.table::uniqueN(olink_subset, "eid") # 53013
# 2923*53013 > nrow(olink_subset) # TRUE
# olink_subset_wide = olink_subset[, .(eid, protein_id, result)] %>%
#   data.table::dcast(
#     .,
#     eid ~ protein_id,
#     value.var = "result",
#     fill = NA
#   )
# olink_subset_wide %>%
#   data.table::fwrite(
#     file.path(inPath, "olink_subset_instance0_wide.csv"),
#     col.names = TRUE,
#     row.names = FALSE,
#     sep = ","
#   )
# olink_subset_wide %>% dim()
# olink_subset_wide %>% names() %>% head()
# protein_measured_eid = olink_subset_wide[, .(eid)] %>%
#   dplyr::distinct()
# protein_measured_eid %>% dim()
# # length(protein_measured_eid) # 53013
# protein_measured_eid %>%
#   data.table::fwrite(
#     file.path(inPath, "olink_protein_measured_eid.txt"),
#     col.names = TRUE,
#     row.names = FALSE,
#     sep = "\t"
#   )

# ## --- Part 2: join with covars data ---
# protein olink data
inPath = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/olink_proteins"
olink_subset_wide = data.table::fread(
  file.path(inPath, "olink_subset_instance0_wide.csv"),
  header = TRUE
)
olink_subset_wide %>% dim()
protein_measured_eid = data.table::fread(
  file.path(inPath, "olink_protein_measured_eid.txt"),
  header = TRUE
)
protein_measured_eid %>% dim()

# select eligible pre-pca european data
T001EuropeanPrePCAID= data.table::fread(
  "WGS_GWAS_and_MR/output/T001_EuropeanPrePCAID.txt",
  header = FALSE
)
T001EuropeanPrePCAID %>% dim()
T001EuropeanPrePCAID %>% head()
data.table::setnames(T001EuropeanPrePCAID, c("V1", "V2"), c("eid", "eid1"))
T001EuropeanPrePCAID[, eid1 := NULL]

# outdated protein olink data
# protein_olink= data.table::fread(
#   "/mnt/lsy/OS5300/user/lsy-bianshengzhe/Project/Pro6_protein0713/raw_download_data/Olink_protein_DPdata/olink_data.txt",
#   header = TRUE,
# )
# protein_olink %>% dim()
# protein_olink %>% head()
# protein_olink_eid= protein_olink[, .(eid)] %>%
#   unique(., by= "eid")
# protein_olink_eid %>% dim()

# --- Part 2.1 ---
phenoFile = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt"
covarFile = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt"
pheno = data.table::fread(phenoFile)
covar = data.table::fread(covarFile)
catCovarList = c(
    "Smoking_status","Alcohol_intake_frequency","Genotype_measurement_batch"
)
purrr::map(catCovarList, ~ table(covar[[.x]], useNA = "always"))
covar[, (catCovarList) := lapply(.SD, as.factor), .SDcols = catCovarList]
purrr::map(catCovarList, ~ levels(covar[[.x]]))
# Merge pheno and covar
pheno %>% dim() # 203972
covar %>% dim() # 203972
pheno_covar = pheno[covar, on = c("FID", "IID"), nomatch = 0]
pheno_covar %>% dim() # 203972
pheno_covar[, `:=`(eid = IID, FID = NULL, IID = NULL)]
euros_pheno_covar = T001EuropeanPrePCAID[pheno_covar, on = "eid"]
message("Total European pre-PCA samples with both phenotype and covariates: ", nrow(euros_pheno_covar))
MR_samples_protein = euros_pheno_covar[!protein_measured_eid, on = "eid"]
message("Total European pre-PCA samples eligible for MR analysis: ", nrow(MR_samples_protein))
MR_samples_protein[, .(eid)] %>%
  dplyr::distinct() %>%
  data.table::fwrite(
    "WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCAID.txt",
    col.names = FALSE,
    row.names = FALSE,
    sep = "\t"
  )
outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/olink_proteins"
saveRDS(MR_samples_protein,
        file = file.path(outputDir, "CIN3plus_proteomic_MR_samples_phenos.rds"))
proteins_corr_data = euros_pheno_covar[olink_subset_wide, on = "eid"]
message("Total European pre-PCA samples with both phenotype, covariates and protein measurements: ", nrow(proteins_corr_data))
saveRDS(proteins_corr_data,
        file = file.path(outputDir, "CIN3plus_proteomic_proteins_corr_full_data.rds"))












# # metabolomics data
# metabolomics_data_1= data.table::fread(
#   "/mnt/lsy/OS5300/user/lsy-bianshengzhe/Project/Pro7_NMRmetabo0821/1.metab/1.1_metab_50w.tab",
#   header = TRUE,
# )
# metabolomics_data_1 %>% dim()
# metabolomics_data_1 %>% head()
# metabolomics_data_1 %>% names() %>% head()
# metabolomics_data_2= metabolomics_data_1 %>%
#   filter(
#     rowSums(is.na(
#       across(-contains(".eid"))
#     )) < ncol(select(., -contains(".eid")))
#   )
# # get eid
# metabolomics_data_2_eid= metabolomics_data_2[, .(f.eid)] %>%
#   unique(., by= "f.eid")
# metabolomics_data_2_eid %>% dim()
# metabolomics_data_2_eid %>% head()
# setnames(metabolomics_data_2_eid, "f.eid", "eid")

# # get european samples used for MR analysis
# setkeyv(T001EuropeanPrePCAID, c("eid"))
# setkeyv(protein_olink_eid, c("eid"))
# setkeyv(metabolomics_data_2_eid, c("eid"))
# MR_samples_protein= T001EuropeanPrePCAID[!protein_olink_eid,]
# MR_samples_metabolomics= T001EuropeanPrePCAID[!metabolomics_data_2_eid,]
# T001EuropeanPrePCAID %>% dim()
# MR_samples_protein %>% dim()
# MR_samples_metabolomics %>% dim()



# file.remove(file.path(getwd(), "WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCAID.txt"))
# MR_samples_protein %>% head
# MR_samples_protein %>%
#   fwrite(
#     "WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCAID.txt",
#     col.names = FALSE,
#     row.names = FALSE,
#     sep = "\t"
#   )
# file.remove(file.path(getwd(), "WGS_GWAS_and_MR/output/T005_MR_metabolomics_EuropeanPrePCAID.txt"))
# MR_samples_metabolomics %>% head
# MR_samples_metabolomics %>%
#   fwrite(
#     "WGS_GWAS_and_MR/output/T005_MR_metabolomics_EuropeanPrePCAID.txt",
#     col.names = FALSE,
#     row.names = FALSE,
#     sep = "\t"
#   )




# # # T002_EuropeanPrePCA_outcome
# # T002_EuropeanPrePCA_outcome= fread(
# #   "WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome.txt",
# #   header = FALSE
# # ) %>%
# #   rename(
# #     eid= V1,
# #     eligible_cc= V2,
# #     eligible_cin3= V3,
# #     eligible_cc_cin3= V4
# #   )
# # T002_EuropeanPrePCA_outcome %>% head()
# # setkeyv(T002_EuropeanPrePCA_outcome, c("eid"))

# # file.remove("WGS_GWAS_and_MR/output/T005_MR_EuropeanPrePCA_outcome.txt")
# # T002_EuropeanPrePCA_outcome[!protein_olink_eid,] %>%
# #   fwrite(
# #     "WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCA_outcome.txt",
# #     col.names = FALSE,
# #     row.names = FALSE,
# #     sep = "\t"
# #   )
# # T002_EuropeanPrePCA_outcome[!metabolomics_data_2_eid,] %>%
# #   fwrite(
# #     "WGS_GWAS_and_MR/output/T005_MR_metabolomics_EuropeanPrePCA_outcome.txt",
# #     col.names = FALSE,
# #     row.names = FALSE,
# #     sep = "\t"
# #   )


# # # T002_EuropeanPrePCA_outcome_recode_cc_cin3
# # T002_EuropeanPrePCA_outcome_recode_cc_cin3= fread(
# #   "WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome_recode_cc_cin3.txt",
# #   header = FALSE
# # ) %>%
# #   rename(
# #     eid= V1,
# #     eligible_cc_cin3= V2
# #   )
# # T002_EuropeanPrePCA_outcome_recode_cc_cin3 %>% head()
# # setkeyv(T002_EuropeanPrePCA_outcome_recode_cc_cin3, c("eid"))


# # file.remove("WGS_GWAS_and_MR/output/T005_MR_EuropeanPrePCA_outcome_recode_cc_cin3.txt")
# # T002_EuropeanPrePCA_outcome_recode_cc_cin3[!protein_olink_eid,] %>%
# #   fwrite(
# #     "WGS_GWAS_and_MR/output/T005_MR_protein_EuropeanPrePCA_outcome_recode_cc_cin3.txt",
# #     col.names = FALSE,
# #     row.names = FALSE,
# #     sep = "\t"
# #   )
# # T002_EuropeanPrePCA_outcome_recode_cc_cin3[!metabolomics_data_2_eid,] %>%
# #   fwrite(
# #     "WGS_GWAS_and_MR/output/T005_MR_metabolomics_EuropeanPrePCA_outcome_recode_cc_cin3.txt",
# #     col.names = FALSE,
# #     row.names = FALSE,
# #     sep = "\t"
# #   )
