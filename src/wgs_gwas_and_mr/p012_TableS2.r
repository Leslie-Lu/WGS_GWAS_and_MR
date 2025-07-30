###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p012_TableS2.r
# DESCRIPTION       : Table S2 and S3 for all ethnicities and the Europeans
# DATE CREATED      : 2025-05-24
# INPUT             : ./data/output/D006EligibleCasesandControls.csv
#                     ./data/output/D008EuropeanPrePCA.csv
# OUTPUT            : ./data/output/D009_GWAS_CIN3_European.csv
#                     ./data/output/D009_GWAS_CC_European.csv
#                     ./data/output/D009_GWAS_CIN3Plus_European.csv
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-05-24
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

# Part 1
# load data
D006All= data.table::fread("./data/output/D006EligibleCasesandControls.csv")
D006All %>% dim()
D006All %>% names()
D006All %>% glimpse()

D006All %>% na.omit() %>% dim()

# in all ethnicities
# Phenotype1: of CIN3+ (eligible_cc_cin3)
# D006All$eligible_cc_cin3 %>% table(useNA = "always")
# Phenotype2: of CC (eligible_cin3==0)
# D006All$eligible_cc %>% table(useNA = "always")
# D006All$eligible_cin3 %>% table(useNA = "always")
# Phenotype3: of CIN3+ (eligible_cc==0)
PCIN3Plus= D006All %>%
  # select(
  #   -c(eid,eligible_cc,eligible_cin3)
  # ) %>%
  filter(
    # eligible_cin3==0
    eligible_cc==0
  ) %>%
  select(
    # -c(eid, eligible_cin3, eligible_cc_cin3)
    -c(eid, eligible_cc, eligible_cc_cin3)
  ) %>%
  rename(
    "Age_at_recruitment"= "p21022",
    "Body_mass_index"= "p21001_i0",
    "Townsend_deprivation_index_at_recruitment"= "p22189",
    "Ethnic_background"= "p21000",
    "Smoking_status"= "p20116",
    "Alcohol_intake_frequency"= "p1558"
  )
PCIN3Plus_dat= PCIN3Plus %>%
  mutate(
    # eligible_cc_cin3= factor(eligible_cc_cin3, levels = c(1, 0), labels = c("Cases", "Controls")),
    # eligible_cc= factor(eligible_cc, levels = c(1, 0), labels = c("Cases", "Controls")),
    eligible_cin3= factor(eligible_cin3, levels = c(1, 0), labels = c("Cases", "Controls")),
    Ethnic_background= factor(
      Ethnic_background,
      levels = c(1, 2, 3, 4, 5, 6, 7),
      labels = c(
        "White", "Mixed", "Asian or Asian British", "Black or Black British",
        "Chinese", "Other ethnic group", "Do not know"
      ),
      ordered = TRUE
    ),
    European_ancestry= factor(
      European_ancestry,
      levels = c(1, 0),
      labels = c("European ancestry", "Non-European ancestry"),
    ),
    Smoking_status= factor(
      Smoking_status,
      levels = c(0, 1, 2, 3),
      labels = c("Never", "Previous", "Current", "Do not know"),
      ordered = TRUE
    ),
    Alcohol_intake_frequency= factor(
      Alcohol_intake_frequency,
      levels = c(1, 2, 3, 4, 5, 6, 7),
      labels = c(
        "Daily or almost daily", "Three or four times a week",
        "Once or twice a week", "One to three times a month",
        "Special occasions only", "Never", "Do not know"
      ),
      ordered = TRUE
    ),
    Genotype_measurement_batch= factor(
      Genotype_measurement_batch,
      levels = c(1, 2, 3),
      labels = c(
        "BiLEVE", "Axiom", "Do not know"
      ),
      ordered = TRUE
    ),
    Country_of_birth= factor(
      Country_of_birth,
      levels = c(1, 2, 3, 4),
      labels = c(
        "England", "Wales", "Scotland", "Other countries"
      ),
      ordered = TRUE
    ),
  )
# Table1(
#   PCIN3Plus_dat,
#   "eligible_cc_cin3",
#   setdiff(names(PCIN3Plus_dat), "eligible_cc_cin3"),
#   result_dir = "output/Tables/",
# )
# Table1(
#   PCIN3Plus_dat,
#   "eligible_cc",
#   setdiff(names(PCIN3Plus_dat), "eligible_cc"),
#   result_dir = "output/Tables/",
# )
Table1(
  PCIN3Plus_dat,
  "eligible_cin3",
  setdiff(names(PCIN3Plus_dat), "eligible_cin3"),
  result_dir = "output/Tables/",
)

# Part 2
# load data
D008European= data.table::fread("./data/output/D008EuropeanPrePCA.csv")
D008European %>% dim()
D008European %>% names()
D008European %>% glimpse()

# Output three datasets with different phenotypes for the european ancestry
D008European %>% head()
# Outcome: CIN3+
D008European %>%
  select(-c(eligible_cc, eligible_cin3)) %>%
  rename(
    "Age_at_recruitment"= "p21022",
    "Body_mass_index"= "p21001_i0",
    "Townsend_deprivation_index_at_recruitment"= "p22189",
    # "Ethnic_background"= "p21000",
    "Smoking_status"= "p20116",
    "Alcohol_intake_frequency"= "p1558"
  ) %>%
  fwrite(
    "./data/output/D009_GWAS_CIN3Plus_European.csv",
    row.names = FALSE
  )
# Outcome: CC
D008European %>%
  filter(
    eligible_cin3==0
  ) %>%
  select(-c(eligible_cin3, eligible_cc_cin3)) %>%
  rename(
    "Age_at_recruitment"= "p21022",
    "Body_mass_index"= "p21001_i0",
    "Townsend_deprivation_index_at_recruitment"= "p22189",
    # "Ethnic_background"= "p21000",
    "Smoking_status"= "p20116",
    "Alcohol_intake_frequency"= "p1558"
  ) %>%
  fwrite(
    "./data/output/D009_GWAS_CC_European.csv",
    row.names = FALSE
  )
# Outcome: CIN3
D008European %>%
  filter(
    eligible_cc==0
  ) %>%
  select(-c(eligible_cc, eligible_cc_cin3)) %>%
  rename(
    "Age_at_recruitment"= "p21022",
    "Body_mass_index"= "p21001_i0",
    "Townsend_deprivation_index_at_recruitment"= "p22189",
    # "Ethnic_background"= "p21000",
    "Smoking_status"= "p20116",
    "Alcohol_intake_frequency"= "p1558"
  ) %>%
  fwrite(
    "./data/output/D009_GWAS_CIN3_European.csv",
    row.names = FALSE
  )

D008European %>% na.omit() %>% dim()

# in european ancestry
# Phenotype1: of CIN3+ (eligible_cc_cin3)
# D008European$eligible_cc_cin3 %>% table(useNA = "always")
# Phenotype2: of CC (eligible_cin3==0)
# D008European$eligible_cc %>% table(useNA = "always")
# D008European$eligible_cin3 %>% table(useNA = "always")
# Phenotype3: of CIN3 (eligible_cc==0)
D008European_P= D008European %>%
  # select(
  #   -c(eid,eligible_cc,eligible_cin3)
  # ) %>%
  filter(
    # eligible_cin3==0
    eligible_cc==0
  ) %>%
  select(
    # -c(eid, eligible_cin3, eligible_cc_cin3)
    -c(eid, eligible_cc, eligible_cc_cin3)
  ) %>%
  rename(
    "Age_at_recruitment"= "p21022",
    "Body_mass_index"= "p21001_i0",
    "Townsend_deprivation_index_at_recruitment"= "p22189",
    # "Ethnic_background"= "p21000",
    "Smoking_status"= "p20116",
    "Alcohol_intake_frequency"= "p1558"
  )
D008European_P_dat= D008European_P %>%
  mutate(
    # eligible_cc_cin3= factor(eligible_cc_cin3, levels = c(1, 0), labels = c("Cases", "Controls")),
    # eligible_cc= factor(eligible_cc, levels = c(1, 0), labels = c("Cases", "Controls")),
    eligible_cin3= factor(eligible_cin3, levels = c(1, 0), labels = c("Cases", "Controls")),
    # Ethnic_background= factor(
    #   Ethnic_background,
    #   levels = c(1, 2, 3, 4, 5, 6, 7),
    #   labels = c(
    #     "White", "Mixed", "Asian or Asian British", "Black or Black British",
    #     "Chinese", "Other ethnic group", "Do not know"
    #   ),
    #   ordered = TRUE
    # ),
    # European_ancestry= factor(
    #   European_ancestry,
    #   levels = c(1, 0),
    #   labels = c("European ancestry", "Non-European ancestry"),
    # ),
    Smoking_status= factor(
      Smoking_status,
      levels = c(0, 1, 2, 3),
      labels = c("Never", "Previous", "Current", "Do not know"),
      ordered = TRUE
    ),
    Alcohol_intake_frequency= factor(
      Alcohol_intake_frequency,
      levels = c(1, 2, 3, 4, 5, 6, 7),
      labels = c(
        "Daily or almost daily", "Three or four times a week",
        "Once or twice a week", "One to three times a month",
        "Special occasions only", "Never", "Do not know"
      ),
      ordered = TRUE
    ),
    Genotype_measurement_batch= factor(
      Genotype_measurement_batch,
      levels = c(1, 2, 3),
      labels = c(
        "BiLEVE", "Axiom", "Do not know"
      ),
      ordered = TRUE
    ),
    Country_of_birth= factor(
      Country_of_birth,
      levels = c(1, 2, 3, 4),
      labels = c(
        "England", "Wales", "Scotland", "Other countries"
      ),
      ordered = TRUE
    ),
  )
# Table1(
#   D008European_P_dat,
#   "eligible_cc_cin3",
#   setdiff(names(D008European_P_dat), "eligible_cc_cin3"),
#   result_dir = "output/Tables/",
# )
# Table1(
#   D008European_P_dat,
#   "eligible_cc",
#   setdiff(names(D008European_P_dat), "eligible_cc"),
#   result_dir = "output/Tables/",
# )
# Table1(
#   D008European_P_dat,
#   "eligible_cin3",
#   setdiff(names(D008European_P_dat), "eligible_cin3"),
#   result_dir = "output/Tables/",
# )
