#!/bin/bash
###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p014_regenie_euro_cin3plus.sh
# DESCRIPTION       : GWAS in European ancestry for outcome CIN3+ using regenie
# DATE CREATED      : 2025-05-26
# INSPIRED BY       : https://rgcgithub.github.io/regenie/recommendations/#step-1
#                     https://documentation.dnanexus.com/developer/apps/intro-to-building-apps
#                     https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/running-analysis-jobs/custom-app
#                     https://documentation.dnanexus.com/developer/apps/app-build-process
#                     https://documentation.dnanexus.com/developer/apps/transitioning-from-applets-to-apps#how-to-make-the-transition
#                     https://community.ukbiobank.ac.uk/hc/en-gb/articles/20527215701533-Creating-a-workflow-customising-your-own-tools-on-the-UKB-RAP
# INPUT             : 
# REGENIE VERSION   : 4.1
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-05-26
# REASON            : Initial version
################################################################################################

# regenie version in dnanexus: 2.0.3
# We used regenie version 4.1 for our analysis.

## Pre-pocessing
### Preparing genotype files
# Note: regenie will throw an error if a low-variance SNP is included in the step 1 run.
# Hence, the user should run adequate QC filtering prior to running regenie to identify and remove such SNPs.

# Sample inclusion/exclusion file format: No header. Each line starts with individual FID IID. Space/tab separated.
# Covariate file format: Line 1 : Header with FID, IID and C covariate names. Followed by lines of C+2 values. Space/tab separated.
# Phenotype file format: Line 1 : Header with FID, IID and P phenotypes names. Followed by lines of P+2 values. Space/tab separated.
# Each line contains individual FID and IID followed by P phenotype values (for binary traits, must be coded as 0=control, 1=case, NA=missing unless using --1).



## Step 1: Whole genome model fitting
# In Step 1, the whole genome regression model is fit to the traits, and a set of genomic predictions are produced as output.
# We recommend to run regenie using multi-threading (8+ threads) which will decrease the overall runtime of the program.
# Running step 1 of regenie (by default, all available threads are used)
./regenie \
  --step 1 \
  --pgen eligible_european_plink2 \
  --keep T001_EuropeanPrePCAID.txt \
  --phenoFile ukb_phenotypes_strict.txt \
  --covarFile ukb_covariates.txt \
  --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
  --strict \
  --bsize 1000 \
  --loocv \
  --lowmem \
  --lowmem-prefix tmpdir/regenie_tmp_preds \
  --write-null-firth \
  --out step1_strict_euro_cin3plus
# a file ending with .loco which contain the genetic predictions using a LOCO scheme that will be needed for step 2,
# as well as a prediction list file step1_strict_euro_cin3plus_pred.list, which lists the names of these predictions files and can be used as input for step 2.
# option --write-null-firth: the estimates for approximate Firth under the null will be written to files file_1.firth,...,file_P.firth (P phenotypes)
# and the list of these files is written to step1_strict_euro_cin3plus_firth.list (Note that it assumes the same set of covariates are used in Step 1 and 2).


## Step 2: Single-variant association testing
# Tests a large set of markers for association with the phenotype conditional upon the prediction from the regression model in Step 1.
# We can use the same Step 1 output to test on array, exome or imputed variants.
# Step 2 of regenie can be run in parallel across chromosomes.
# We recommend to split the runs over chromosomes (using 8+ threads).

# Running regenie on chromosome 1 and using the fast Firth correction as fallback for p-values below 0.01.
./regenie \
  --step 2 \
  --pgen ukb24308_c1_b0_v1 \
  --keep T001_EuropeanPrePCAID.txt \
  --ref-first \
  --phenoFile ukb_phenotypes_strict.txt \
  --covarFile ukb_covariates.txt \
  --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
  --strict \
  --bsize 400 \
  --firth --approx \
  --pThresh 0.01 \
  --pred step1_strict_euro_cin3plus_pred.list \
  --split \
  --use-null-firth step1_strict_euro_cin3plus_firth.list \
  --out step2_strict_euro_cin3plus_chr1
# This will create separate association results files for each phenotype as step2_strict_euro_cin3plus_chr1_*.regenie

## Step 2: Gene-based testing
# Instead of performing single-variant association tests, multiple variants can be aggregated in a given region, such as a gene.
# This can be especially helpful when testing rare variants as single-vatiant tests usuaally have lower power performance.
# To avoid inflation in the gene-based tets due to rare variants as well as reduce computation time, we have implemented the collapsing approach proposed in SAIGE-GENE+,
# where ultra-rare variants are aggregated into a mask.
# When running the SKAT/ACAT gene-based tests, we recommend to use at most 2 threads and instead parallelize the runs over partitions of the genome (e.g. groups of genes).

# Annotation input files: to define variant sets and functional annotations which will be used to generate masks.






# Burden tests
# The tests collapse wariants into a single variable which is then tested for association with the phenotype.
# Hence, they are more powerful when variants have effects in the same diresction and of similar magnitude.
# 







