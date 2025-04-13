###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p003_tidy_phenotype_data.r
# DESCRIPTION       : Tidy phenotype data for WGS GWAS and MR
# DATE CREATED      : 2025-04-11
# INPUT             : data\input\PhenotypeData_20250331.csv
# OUTPUT            : data\output\PhenotypeData_20250331_tidy.csv
#                     data\output\PhenotypeData_20250331_tidy.rds
# R VERSION         : 4.3.1
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-04-13
# REASON            : Initial version
################################################################################################
rm(list = ls())
gc()

library(magrittr)
library(dplyr)
library(data.table)
library(purrr)

# load data
phenotype_data= data.table::fread("./data/input/PhenotypeData_20250331.csv")
phenotype_data %>% dim()
phenotype_data %>% colnames() %>% head()
phenotype_data$V1 %>% head()
# remove the first column
phenotype_data[, V1 := NULL]
phenotype_data %>% dim()

phenotype_data %>% glimpse()
# only incude the women data
phenotype_data %>%
  select(p31, p22001) %>%
  purrr::map(
    ~ table(.x, useNA = "always")
  )
women_data= phenotype_data %>%
  filter(
    (p22001==0 & p31==0) | (is.na(p22001) & (p31==0))
  ) %>%
  select(-c(p31, p22001))
women_data %>% dim()

# tidy the features
tidy_women_data= women_data %>%
  filter(
    !is.na(p21022),           # Age at recruitment
    !is.na(p21001_i0),        # Body mass index (BMI)
    is.na(p22027),            # Outliers for heterozygosity or missing rate
    !is.na(p22189),           # Townsend deprivation index at recruitment
    # p53_i0, Date_of_death, p40005_i is IDate
  ) %>%
  mutate(
    p21000= case_when(
      # Ethnic background
      p21000_i0 %in% c(1, 1001, 1002, 1003) ~ 1,        #	White
      p21000_i0 %in% c(2, 2001, 2002, 2003, 2004) ~ 2,  # Mixed
      p21000_i0 %in% c(3, 3001, 3002, 3003, 3004) ~ 3,  # Asian or Asian British
      p21000_i0 %in% c(4, 4001, 4002, 4003) ~ 4,        # Black or Black British
      p21000_i0 == 5 ~ 5,                               # Chinese
      p21000_i0 == 6 ~ 6,                               # Other ethnic group
      p21000_i0 %in% c(-1, -3, NA) ~ 7,                 # Do not know
      TRUE ~ 999                                        # error
    ),
    # Smoking status
    p20116= dplyr::case_when(
      p20116_i0 == 1 ~ 1,             #	Previous
      p20116_i0 == 2 ~ 2,             # Current
      p20116_i0 == 0 ~ 0,             # Never
      p20116_i0 %in% c(-3, NA) ~ 3,   # Do not know
      TRUE ~ 999                      # error
    ),
    # Alcohol intake frequency
    p1558= case_when(
      p1558_i0 == 1 ~ 1,           # Daily or almost daily
      p1558_i0 == 2 ~ 2,           # Three or four times a week
      p1558_i0 == 3 ~ 3,           # Once or twice a week
      p1558_i0 == 4 ~ 4,           # One to three times a month
      p1558_i0 == 5 ~ 5,           # Special occasions only
      p1558_i0 == 6 ~ 6,           # Never
      p1558_i0 %in% c(-3, NA) ~ 7, # Do not know
      TRUE ~ 999                   # error
    ),
    # Genotype measurement batch
    Genotype_measurement_batch= case_when(
      p22000 %in% c(-11:-1,1000) ~ 1, # 1000, BiLEVE
      p22000 %in% c(1:95, 2000) ~ 2,  # 2000, Axiom
      is.na(p22000) ~ 3,              # 0, 	  Do not know
      TRUE ~ 999                      # error
    ),
    # Date of death
    Date_of_death= case_when(
      !is.na(p40000_i0) ~ p40000_i0,
      is.na(p40000_i0) & !is.na(p40000_i1) ~ p40000_i1,
      is.na(p40000_i0) & is.na(p40000_i1) ~ p40000_i0,
      TRUE ~ p40000_i0
    ),
    # p40006_i, p40001_i, p40002_i, p41202, p41203, p41204, p41205, p41270, p41271 is character
    # p40013_i, p20001_i, p20002_i is integer
    across(
      c(starts_with("p40006_i"),
        starts_with("p40013_i"),
        starts_with("p20001_i"),
        starts_with("p40001_i"),
        starts_with("p40002_i"),
        starts_with("p41202"),
        starts_with("p41203"),
        starts_with("p41204"),
        starts_with("p41205"),
        starts_with("p20002_i"),
        starts_with("p41270"),
        starts_with("p41271"),
      ),
      ~ as.character(.x)
    ),
    # Country of birth (UK/elsewhere)
    Country_of_birth= case_when(
      !is.na(p1647_i0) ~ p1647_i0,
      is.na(p1647_i0) & !is.na(p1647_i1) ~ p1647_i1,
      is.na(p1647_i0) & is.na(p1647_i1) & !is.na(p1647_i2) ~ p1647_i2,
      is.na(p1647_i0) & is.na(p1647_i1) & is.na(p1647_i2) ~ p1647_i0,
    ),
    Country_of_birth= dplyr::case_when(
      Country_of_birth == 1 ~ 1, # England
      Country_of_birth == 2 ~ 2, # Wales
      Country_of_birth == 3 ~ 3, # Scotland
      TRUE ~ 4,             # Other countries
    )
  ) %>%
  select(
    -c(
      p21001_i1, p21001_i2, p21001_i3,
      p21000_i0, p21000_i1, p21000_i2, p21000_i3, p22006,
      p22027,
      p20116_i0, p20116_i1, p20116_i2, p20116_i3,
      p1558_i0, p1558_i1, p1558_i2, p1558_i3,
      p22000,
      p22009_a1, p22009_a2, p22009_a3, p22009_a4, p22009_a5,
      p22009_a6, p22009_a7, p22009_a8, p22009_a9, p22009_a10,
      # remove the Genetic principal components
      p22009_a11, p22009_a12, p22009_a13, p22009_a14, p22009_a15,
      p22009_a16, p22009_a17, p22009_a18, p22009_a19, p22009_a20,
      p22009_a21, p22009_a22, p22009_a23, p22009_a24, p22009_a25,
      p22009_a26, p22009_a27, p22009_a28, p22009_a29, p22009_a30,
      p22009_a31, p22009_a32, p22009_a33, p22009_a34, p22009_a35,
      p22009_a36, p22009_a37, p22009_a38, p22009_a39, p22009_a40,
      p53_i1, p53_i2, p53_i3,
      p40000_i0, p40000_i1,
      p1647_i0, p1647_i1, p1647_i2
    )
  )
tidy_women_data %>% glimpse()

# used for next step
D001TidyWomen= tidy_women_data %>%
  select(-c(
    starts_with("p53_i0"),
    starts_with("p40005_i"),
    starts_with("p40006_i"),
    starts_with("p40013_i"),
    starts_with("p20001_i"),
    starts_with("p40001_i"),
    starts_with("p40002_i"),
    starts_with("p41202"),
    starts_with("p41203"),
    starts_with("p41204"),
    starts_with("p41205"),
    starts_with("p20002_i"),
    starts_with("p41270"),
    starts_with("p41271"),
    starts_with("Date_of_death")
  ))
D001TidyWomen %>% glimpse()
D001TidyWomen %>%
  data.table::fwrite(
    "./data/output/D001TidyWomen.csv",
    row.names = FALSE
  )
D002DiagnosisCodeandDate= tidy_women_data %>%
  select(c(
    eid,
    starts_with("p53_i0"),
    starts_with("p40005_i"),
    starts_with("p40006_i"),
    starts_with("p40013_i"),
    starts_with("p20001_i"),
    starts_with("p40001_i"),
    starts_with("p40002_i"),
    starts_with("p41202"),
    starts_with("p41203"),
    starts_with("p41204"),
    starts_with("p41205"),
    starts_with("p20002_i"),
    starts_with("p41270"),
    starts_with("p41271"),
    starts_with("Date_of_death")
  ))
D002DiagnosisCodeandDate %>% glimpse()
D002DiagnosisCodeandDate %>%
  data.table::fwrite(
    "./data/output/D002DiagnosisCodeandDate.csv",
    row.names = FALSE
  )
D003TotalEligibleWomenID= tidy_women_data %>%
  select(eid)
D003TotalEligibleWomenID %>%
  data.table::fwrite(
    "./data/output/D003TotalEligibleWomenID.csv",
    row.names = FALSE
  )
