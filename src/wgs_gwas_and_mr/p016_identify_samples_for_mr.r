###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p030_identify_samples_for_mr.r
# DESCRIPTION       : To identify samples for Mendelian Randomization.
# DATE CREATED      : 2025-06-11
# INPUT             : 
# OUTPUT            : 
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-06-11
# REASON            : Initial version
################################################################################################
rm(list = ls())
gc()

# lulab.utils::test_mirror("China")
# options(repos = c(CRAN = 'https://mirrors.ustc.edu.cn/CRAN/'))
# install.packages("data.table")
library(lulab.utils)
library(magrittr)
library(dplyr)
library(data.table)
library(purrr)

# select eligible pre-pca european data
T001EuropeanPrePCAID= data.table::fread(
  "WGS_GWAS_and_MR/output/T001_EuropeanPrePCAID.txt",
  header = FALSE
)
T001EuropeanPrePCAID %>% dim()
T001EuropeanPrePCAID %>% names()
T001EuropeanPrePCAID %<>%
  rename(
    eid= V1,
    eid1= V2
  )

# protein olink data
protein_olink= data.table::fread(
  "/mnt/lsy/OS5300/user/lsy-bianshengzhe/Project/Pro6_protein0713/raw_download_data/Olink_protein_DPdata/olink_data.txt",
  header = TRUE,
)
protein_olink %>% dim()
protein_olink_eid= protein_olink[, .(eid)] %>%
  unique(., by= "eid")
protein_olink_eid %>% dim()

# metabolomics data
metabolomics_data_1= data.table::fread(
  "/mnt/lsy/OS5300/user/lsy-bianshengzhe/Project/Pro7_NMRmetabo0821/1.metab/1.1_metab_50w.tab",
  header = TRUE,
)
metabolomics_data_1 %>% dim()
metabolomics_data_1 %>% head()
metabolomics_data_1 %>% names() %>% head()
metabolomics_data_2= metabolomics_data_1 %>%
  filter(
    rowSums(is.na(
      across(-contains(".eid"))
    )) < ncol(select(., -contains(".eid")))
  )
# get eid
metabolomics_data_2_eid= metabolomics_data_2[, .(f.eid)] %>%
  unique(., by= "f.eid")
metabolomics_data_2_eid %>% dim()
metabolomics_data_2_eid %>% head()
setnames(metabolomics_data_2_eid, "f.eid", "eid")

# get european samples used for MR analysis
setkeyv(T001EuropeanPrePCAID, c("eid"))
setkeyv(protein_olink_eid, c("eid"))
setkeyv(metabolomics_data_2_eid, c("eid"))
MR_samples= T001EuropeanPrePCAID[!protein_olink_eid,] %>%
  .[!metabolomics_data_2_eid,]
MR_samples %>% head()
MR_samples %>%
  fwrite(
    "WGS_GWAS_and_MR/output/T005_MR_EuropeanPrePCAID.txt",
    col.names = FALSE,
    row.names = FALSE,
    sep = "\t"
  )

# T002_EuropeanPrePCA_outcome
T002_EuropeanPrePCA_outcome= fread(
  "WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome.txt",
  header = FALSE
) %>%
  rename(
    eid= V1,
    eligible_cc= V2,
    eligible_cin3= V3,
    eligible_cc_cin3= V4
  )
T002_EuropeanPrePCA_outcome %>% head()
setkeyv(T002_EuropeanPrePCA_outcome, c("eid"))
T002_EuropeanPrePCA_outcome[!protein_olink_eid,] %>%
  .[!metabolomics_data_2_eid,] %>%
  fwrite(
    "WGS_GWAS_and_MR/output/T005_MR_EuropeanPrePCA_outcome.txt",
    col.names = FALSE,
    row.names = FALSE,
    sep = "\t"
  )



# T002_EuropeanPrePCA_outcome_recode_cc_cin3
T002_EuropeanPrePCA_outcome_recode_cc_cin3= fread(
  "WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome_recode_cc_cin3.txt",
  header = FALSE
) %>%
  rename(
    eid= V1,
    eligible_cc_cin3= V2
  )
T002_EuropeanPrePCA_outcome_recode_cc_cin3 %>% head()
setkeyv(T002_EuropeanPrePCA_outcome_recode_cc_cin3, c("eid"))
T002_EuropeanPrePCA_outcome_recode_cc_cin3[!protein_olink_eid,] %>%
  .[!metabolomics_data_2_eid,] %>%
  fwrite(
    "WGS_GWAS_and_MR/output/T005_MR_EuropeanPrePCA_outcome_recode_cc_cin3.txt",
    col.names = FALSE,
    row.names = FALSE,
    sep = "\t"
  )
