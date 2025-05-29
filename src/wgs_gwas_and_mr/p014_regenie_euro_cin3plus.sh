#!/bin/bash
###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p014_regenie_euro_cin3plus.sh
# DESCRIPTION       : GWAS in European ancestry for outcome CIN3+ using regenie
# DATE CREATED      : 2025-05-26
# INSPIRED BY       : https://rgcgithub.github.io/regenie/recommendations/#step-1
# INPUT             : 
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-05-26
# REASON            : Initial version
################################################################################################

## Pre-pocessing
### Preparing genotype files
# Note: regenie will throw an error if a low-variance SNP is included in the step 1 run.
# Hence, the user should run adequate QC filtering prior to running regenie to identify and remove such SNPs.

## Step 1
# In Step 1, the whole genome regression model is fit to the traits, and a set of genomic predictions are produced as output.
# We recommend to run regenie using multi-threading (8+ threads) which will decrease the overall runtime of the program.
# Running step 1 of regenie (by default, all available threads are used)
./regenie \
  --step 1 \
  --pgen eligible_european_plink2 \
  --keep T001_EuropeanPrePCAID.txt \
  --phenoFile ukb_phenotypes_BT.txt \
  --covarFile ukb_covariates.txt \
  --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
  --strict \
  --bsize 1000 \
  --lowmem \
  --lowmem-prefix tmpdir/regenie_tmp_preds \
  --out step1_strict_euro_cin3plus

## Step 2
# We can use the same Step 1 output to test on array, exome or imputed variants.
# Step 2 of regenie can be run in parallel across chromosomes.
# We recommend to split the runs over chromosomes (using 8+ threads).

# Running regenie on chromosome 1 and using the fast Firth correction as fallback for p-values below 0.01.
./regenie \
  --step 2 \
  --pgen ukb24308_c1_b0_v1 \
  --keep T001_EuropeanPrePCAID.txt \
  --ref-first \
  --phenoFile ukb_phenotypes_BT.txt \
  --covarFile ukb_covariates.txt \
  --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
  --strict \
  --bsize 400 \
  --firth --approx --pThresh 0.01 \
  --pred step1_strict_euro_cin3plus_pred.list \
  --split \
  --out step2_strict_euro_cin3plus_chr1







