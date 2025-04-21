###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p009_european_pre_pca.r
# DESCRIPTION       : Pre-processing for European ancestry data
# DATE CREATED      : 2025-04-21
# INPUT             : data\output\D007EligibleCasesandControls_european.csv
#                     output\T001_EuropeanPrePCAID.txt
# OUTPUT            : data\output\D008EuropeanPrePCA.csv
#                     output\T002_EuropeanPrePCA_outcome.txt
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-04-21
# REASON            : Initial version
################################################################################################
rm(list = ls())
gc()

# lulab.utils::test_mirror("China")
# options(repos = c(CRAN = 'https://mirrors.ustc.edu.cn/CRAN/'))
# install.packages("data.table")
library(magrittr)
library(dplyr)
library(data.table)
library(purrr)

# load data
D007European= data.table::fread("./data/output/D007EligibleCasesandControls_european.csv")
D007European %>% dim()
D007European %>% names()
D007European %>% glimpse()

# select eligible pre-pca european data
T001EuropeanPrePCAID= data.table::fread("./output/T001_EuropeanPrePCAID.txt", header = FALSE)
T001EuropeanPrePCAID %>% dim()
T001EuropeanPrePCAID %>% names()
T001EuropeanPrePCAID %<>%
  rename(
    eid= V1,
    eid1= V2
  )
D008EuropeanPrePCA= D007European %>%
  right_join(T001EuropeanPrePCAID, by = "eid") %>%
  select(-c(eid1))
D008EuropeanPrePCA %>% dim()
D008EuropeanPrePCA %>% names()

# output
D008EuropeanPrePCA %>%
  fwrite(
    "./data/output/D008EuropeanPrePCA.csv",
    row.names = FALSE
  )
D008EuropeanPrePCA %>%
  select(
    eid,
    eligible_cc,
    eligible_cin3,
    eligible_cc_cin3
  ) %>%
  fwrite(
    "./output/T002_EuropeanPrePCA_outcome.txt",
    col.names = FALSE,
    row.names = FALSE,
    sep = "\t"
  )
