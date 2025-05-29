###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p005_determine_outcome.r
# DESCRIPTION       : Determine outcome and select eligible cases and controls
# DATE CREATED      : 2025-04-14
# INPUT             : data\output\D005DX_ExcludedWomen_20250527.csv
# OUTPUT            : data\output\D006EligibleCasesandControls.csv
#                     data\output\D006EligibleCasesandControlsID.csv
#                     data\output\D006EligibleCasesandControls_outcome.csv
# R VERSION         : 4.3.1
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-05-27
# REASON            : Double check for the figure of flowchart
################################################################################################
rm(list = ls())
gc()

library(magrittr)
library(dplyr)
library(data.table)
library(purrr)

# load data
dx_data= data.table::fread("./data/output/D005DX_ExcludedWomen_20250527.csv")
dx_data %>% names()
dx_data %>% dim()
dx_data %>%
  select(contains("_dx_case_")) %>%
  purrr::map(
    ~ table(.x, useNA = "always")
  )
# check the number of cases and controls
# Inclusion criteria for cases:
# 1. cervical cancer
# 'C530', 'C531', 'C539', '1800', '1801', '1808', '1809'
dx_inclusion1= dx_data %>%
  select(eid,
         contains("C530_dx_case_"),
         contains("C531_dx_case_"),
         contains("C539_dx_case_"),
         contains("1800_dx_case_"),
         contains("1801_dx_case_"),
         contains("1808_dx_case_"),
         contains("1809_dx_case_")
        ) %>%
  mutate(
    inclusion1= rowSums(across(contains("_dx_case_")), na.rm = TRUE)
  ) %>%
  select(eid, inclusion1)
dx_inclusion1 %>%
  filter(
    inclusion1 > 0
  ) %>%
  nrow()

# 2. CIN3
# 'D060', 'D061', 'D067', 'D069', '2331'
dx_include2= dx_data %>%
  select(eid,
         contains("D060_dx_case_"),
         contains("D061_dx_case_"),
         contains("D067_dx_case_"),
         contains("D069_dx_case_"),
         contains("2331_dx_case_")
        ) %>%
  mutate(
    inclusion2= rowSums(across(contains("_dx_case_")), na.rm = TRUE)
  ) %>%
  select(eid, inclusion2)
dx_include2 %>%
  filter(
    inclusion2 > 0
  ) %>%
  nrow()

# Exclusion criteria for controls (plus not a case):
# 1. Self-reported cervical cancer
# '1041'
dx_exclusion1= dx_data %>%
  select(eid,
         contains("1041_dx_case_")
        ) %>%
  mutate(
    exclusion1= rowSums(across(contains("_dx_case_")), na.rm = TRUE)
  ) %>%
  select(eid, exclusion1)
dx_exclusion1 %>%
  filter(
    exclusion1 > 0
  ) %>%
  nrow()

# 2. Mild, moderate, and severe cervical dysplasia
# 'N870', 'N871', 'N872', '6221', '6222'
dx_exclusion2= dx_data %>%
  select(eid,
         contains("N870_dx_case_"),
         contains("N871_dx_case_"),
         contains("N872_dx_case_"),
         contains("6221_dx_case_"),
         contains("6222_dx_case_")
        ) %>%
  mutate(
    exclusion2= rowSums(across(contains("_dx_case_")), na.rm = TRUE)
  ) %>%
  select(eid, exclusion2)
dx_exclusion2 %>%
  filter(
    exclusion2 > 0
  ) %>%
  nrow()

# 3. Self-reported non-cancer cervical illness
# '1553', '1554', '1555', '1662', '1663'
dx_exclusion3= dx_data %>%
  select(eid,
         contains("1553_dx_case_"),
         contains("1554_dx_case_"),
         contains("1555_dx_case_"),
         contains("1662_dx_case_"),
         contains("1663_dx_case_")
        ) %>%
  mutate(
    exclusion3= rowSums(across(contains("_dx_case_")), na.rm = TRUE)
  ) %>%
  select(eid, exclusion3)
dx_exclusion3 %>%
  filter(
    exclusion3 > 0
  ) %>%
  nrow()

# merge the inclusion and exclusion criteria
dx_criteria= dx_inclusion1 %>%
  left_join(dx_include2, by = "eid") %>%
  left_join(dx_exclusion1, by = "eid") %>%
  left_join(dx_exclusion2, by = "eid") %>%
  left_join(dx_exclusion3, by = "eid") %>%
  mutate(
    eligible_cc= ifelse(
      inclusion1 > 0,
      1,
      0
    ),
    eligible_cin3= ifelse(
      inclusion2 > 0 & inclusion1 == 0,
      1,
      0
    ),
    eligible_cc_cin3= ifelse(
      inclusion1 > 0 | inclusion2 > 0,
      1,
      0
    ),
    exclusion= ifelse(
      exclusion1 > 0 | exclusion2 > 0 | exclusion3 > 0,
      1,
      0
    ),
    eligible_controls= ifelse(
      eligible_cc_cin3 == 0 & exclusion == 0,
      1,
      0
    ),
    eligible= ifelse(
      eligible_cc_cin3 == 1 | eligible_controls == 1,
      1,
      0
    )
  ) %>%
  select(eid,
         eligible_cc,
         eligible_cin3,
         eligible_cc_cin3,
         exclusion,
         eligible_controls,
         eligible
        )
dx_criteria %>%
  select(-eid) %>%
  map(
    ~ table(.x, useNA = "always")
  )
dim(dx_data)[1] - 266601

outcome_data= dx_criteria %>%
  filter(
    eligible == 1
  ) %>%
  select(
    eid,
    eligible_cc,
    eligible_cin3,
    eligible_cc_cin3
  )

outcome_data %>%
  select(-eid) %>%
  map(
    ~ table(.x, useNA = "always")
  )
