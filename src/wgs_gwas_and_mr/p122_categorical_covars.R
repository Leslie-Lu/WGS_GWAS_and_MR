# =========================================================================
# Handling categorical covars
# 
# Author: Zhen Lu
# Date: 2025-12-11
# Version: 0.1.0
# =========================================================================

input_file= "WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt"

dat = data.table::fread(input_file)
dat |> head()
dat[, .(Smoking_status, Alcohol_intake_frequency, Genotype_measurement_batch)] |>
  purrr::map(
    ~ table(.x, useNA = "always")
  )
dat[, `:=` (
  Smoking_status_char = data.table::fcase(
    as.character(Smoking_status) == "0", "Never",
    as.character(Smoking_status) == "1", "Previous",
    as.character(Smoking_status) == "2", "Current",
    as.character(Smoking_status) == "3", "Do_not_know",
    default = NA_character_
  ),
  Alcohol_intake_frequency_char = data.table::fcase(
    as.character(Alcohol_intake_frequency) == "1", "Daily_or_almost_daily",
    as.character(Alcohol_intake_frequency) == "2", "Three_or_four_times_a_week",
    as.character(Alcohol_intake_frequency) == "3", "Once_or_twice_a_week",
    as.character(Alcohol_intake_frequency) == "4", "One_to_three_times_a_month",
    as.character(Alcohol_intake_frequency) == "5", "Special_occasions_only",
    as.character(Alcohol_intake_frequency) == "6", "Never",
    as.character(Alcohol_intake_frequency) == "7", "Do_not_know",
    default = NA_character_
  ),
  Genotype_measurement_batch_char = data.table::fcase(
    as.character(Genotype_measurement_batch) == "1", "BiLEVE",
    as.character(Genotype_measurement_batch) == "2", "Axiom",
    as.character(Genotype_measurement_batch) == "3", "Do_not_know",
    default = NA_character_
  )
)] |>
  _[, `:=` (
    Smoking_status = NULL,
    Alcohol_intake_frequency = NULL,
    Genotype_measurement_batch = NULL
  )]
dat[, .(Smoking_status_char, Alcohol_intake_frequency_char, Genotype_measurement_batch_char)] |>
  purrr::map(
    ~ table(.x, useNA = "always")
  )
dat |> head()
dat |>
  data.table::fwrite(
    file = "WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical.txt",
    sep = "\t",
    na = NA
  )

# #########################################################################
# --- 1. Update on 20251231 ---
# #########################################################################

dat = "WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical.txt"
eid= "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele/T002_CIN3plus_phenotype_20251231_v2.txt"

dat= data.table::fread(
  dat
)
eid= data.table::fread(eid)
eid[, `:=`(
  `#FID`= NULL,
  PHENO1= NULL
)]
dat |> dim()
eid |> dim()
eid |> head()
dat |> head()
# data.table::setnames(eid, "IID", "#IID")

dat_v2= dat[eid, on="IID", nomatch=0]
dat_v2 |> dim()
dat_v2 |> head()
data.table::setnames(dat_v2, "FID", "#FID")
dat_v2 |>
  data.table::fwrite(
    file = "WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical_20251231.txt",
    sep = "\t",
    na = NA
  )
