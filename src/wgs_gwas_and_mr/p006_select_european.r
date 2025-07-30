###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p006_select_european.r
# DESCRIPTION       : Select European
# DATE CREATED      : 2025-04-18
# INPUT             : ./data/output/D006EligibleCasesandControls.csv
# OUTPUT            : data\output\D007EligibleCasesandControls_european.csv
#                     data\output\D007EligibleCasesandControlsID_european.txt
#                     data\output\D007EligibleCasesandControls_outcome_european.csv
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-04-18
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
D006= data.table::fread("./data/output/D006EligibleCasesandControls.csv")
D006 %>% dim()
D006 %>% names()

D006$European_ancestry %>% table(useNA = "always")
# 先只做european的
D007_european= D006 %>%
  filter(
    European_ancestry==1
  ) %>%
  select(-c(European_ancestry, p21000))
D007_european %>% dim()

# output
D007_european %>%
  fwrite(
    "./data/output/D007EligibleCasesandControls_european.csv",
    row.names = FALSE
  )
D007_european %>%
  select(eid) %>%
  mutate(eid1= eid) %>%
  fwrite(
    "./data/output/D007EligibleCasesandControlsID_european.txt",
    row.names = FALSE,
    col.names = FALSE, sep = "\t"
  )
D007_european %>%
  select(
    eid,
    eligible_cc,
    eligible_cin3,
    eligible_cc_cin3
  ) %>%
  fwrite(
    "./data/output/D007EligibleCasesandControls_outcome_european.csv",
    row.names = FALSE
  )
