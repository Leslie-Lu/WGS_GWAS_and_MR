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
mkdir -p /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/tmpdir
source /share/home/lsy_luzhen/software/miniconda3/bin/activate regenie_env
echo 'regenie version:'
regenie --version
regenie \
  --step 1 \
  --bed /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european/european_pre_pca_data_outcome_cc_cin3 \
  --phenoFile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt \
  --bt \
  --covarFile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt \
  --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
  --strict \
  --bsize 1000 \
  --loocv \
  --lowmem \
  --lowmem-prefix /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/tmpdir/regenie_tmp_preds \
  --write-null-firth \
  --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step1/regenie_step1_euro_cin3plus
conda deactivate
# a file ending with .loco which contain the genetic predictions using a LOCO scheme that will be needed for step 2,
# as well as a prediction list file regenie_step1_euro_cin3plus_pred.list, which lists the names of these predictions files and can be used as input for step 2.
# option --write-null-firth: the estimates for approximate Firth under the null will be written to files file_1.firth,...,file_P.firth (P phenotypes)
# and the list of these files is written to regenie_step1_euro_cin3plus_firth.list (Note that it assumes the same set of covariates are used in Step 1 and 2).


## Step 2: Single-variant association testing
# Tests a large set of markers for association with the phenotype conditional upon the prediction from the regression model in Step 1.
# We can use the same Step 1 output to test on array, exome or imputed variants.
# Step 2 of regenie can be run in parallel across chromosomes.
# We recommend to split the runs over chromosomes (using 8+ threads).

# Running regenie on chromosome 1 and using the fast Firth correction as fallback for p-values below 0.01.
regenie \
  --step 2 \
  --pgen WGS_step2_QC \
  --chr \${chr} \
  --phenoFile T002_CIN3plus_phenotype.txt \
  --bt \
  --covarFile T002_CIN3plus_covars.txt \
  --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \
  --strict \
  --bsize 1000 \
  --firth --approx \
  --pThresh 0.01 \
  --pred regenie_step1_euro_cin3plus_pred.list \
  --use-null-firth regenie_step1_euro_cin3plus_firth.list \
  --out regenie_step2_euro_cin3plus_chr\${chr}
# This will create separate association results files for each phenotype as regenie_step2_euro_cin3plus_*.regenie

## Step 2: Gene-based testing
# Instead of performing single-variant association tests, multiple variants can be aggregated in a given region, such as a gene.
# This can be especially helpful when testing rare variants as single-vatiant tests usuaally have lower power performance.
# To avoid inflation in the gene-based tets due to rare variants as well as reduce computation time, we have implemented the collapsing approach proposed in SAIGE-GENE+,
# where ultra-rare variants are aggregated into a mask.


# Annotation input files: to define variant sets and functional annotations which will be used to generate masks.
# Each line contains the variant name, the set/gene name and a single annotation category (space/tab separated).
# Variants not in this file will be assigned to a default "NULL" category. A maximum of 63 annotation categories (+NULL category) is allowed.
# To obtain a single annotation per gene, we could choose the most deleterious functional annotation across the gene transcripts 
# or alternatively use the canonical transcript (note that its definition can vary across software).

# Set list file: to list variants within each set/gene to use when building masks.
# Each line contains the set/gene name followed by a chromosome and physical position for the set/gene, then by a comma-separated list of variants included in the set/gene.

# AAF file
# Both functional annotations and alternative allele frequency (AAF) cutoffs are used when building masks (e.g. only considering LoF sites where AAF is below 1%).
# By default, the AAF for each variant is computed from the sample but alternatively, the user can specify variant AAFs using this file.
# AAF cutoffs
# Option --aaf-bins specifies the AAF upper bounds used to generate burden masks (AAF and not MAF [minor allele frequency] is used when deciding which variants go into a mask).
# By default, a mask based on singleton sites are always included.
# For example, --aaf-bins 0.01,0.05 will generate 3 burden masks for AAFs in [0,0.01], [0,0.05] and singletons.

# Checking input files
# To assess the concordance between the input files for building masks, we can use --check-burden-files which will generate a report in file_masks_report.txt containing:
# for each set, the list the variants in the set-list file which are unrecognized (not genotyped or not present in annotation file for the set)
# for each mask, the list of annotations in the mask definition file which are not in the annotation file
# Additionally, we can use --strict-check-burden to enforce full agreement between the three files (if not, program will terminate) :
# all genotyped variants in the set list file must be in the annotation file (for the corresponding set)
# all annotations in the mask definition file must be present in the annotation file



# build and test masks in Step 2
regenie \
  --step 2 \
  --pgen ukb24308_c1_b0_v1 \ # needs to be updated
  --keep T001_EuropeanPrePCAID.txt \ # needs to be updated
  --phenoFile ukb_phenotypes_strict.txt \ # needs to be updated
  --bt \
  --covarFile ukb_covariates.txt \ # needs to be updated
  --catCovarList Smoking_status,Alcohol_intake_frequency,Genotype_measurement_batch \ # needs to be updated
  --strict \
  --bsize 1000 \
  --firth --approx \
  --pred regenie_step1_euro_cin3plus_pred.list \
  --anno-file example/example_3chr.annotations \ # needs to be updated
  --set-list example/example_3chr.setlist \ # needs to be updated
  --mask-def example/example_3chr.masks \ # needs to be updated
  --aaf-bins 0.1,0.05 \
  --write-mask \
  --out regenie_test_euro_cin3plus_firth
# For each set, this will produce masks using 3 AAF cutoffs (singletons, 5% and 10% AAF).
# The masks are written to PLINK bed file (in regenie_test_euro_cin3plus_firth_masks.{bed,bim,fam})
# and tested for association with each binary trait using Firth approximate test (summary stats in regenie_test_euro_cin3plus_firth_<phenotype_name>.regenie).
# Additionally, a header line is included (starting with ##) which contains mask definition information.
# Masks will have name <set_name>.<mask_name>.<AAF_cutoff> with the chromosome and physical position having been defined in the set list file, 
# and the reference allele being ref, and the alternate allele corresponding to <mask_name>.<AAF_cutoff>.
# When using --rgc-gene-p, it will apply the single p-value per gene GENE_P strategy using all masks.
# Mask file
# This file specifies which annotation categories should be combined into masks.
# Each line contains a mask name followed by a comma-separated list of categories included in the mask (i.e. union is taken over categories).


# SKAT/ACAT tests
# When running the SKAT/ACAT gene-based tests, we recommend to use at most 2 threads and instead parallelize the runs over partitions of the genome (e.g. groups of genes).
# The option --vc-tests is used to specify the gene-based tests to run.
# By default, these tests use all variants in each mask category.
# If you'd like to only include variants whose AAF is below a given threshold ,e.g. only including rare variants, you can use --vc-maxAAF.
# For example, --vc-tests skato,acato-full will run SKATO and ACATO (both using the default grid of 8 rho values for the SKATO models) 
# and the p-values for SKAT, SKATO, ACATV and ACATO will be output.
# Ultra-rare variants (defined by default as MAC ≤ 10, see --vc-MACthr) are collapsed into a burden mask which is then included in the tests instead of the individual variants.
# Joint test for burden masks
# The ACAT test combines the p-values of the individual burden masks using the Cauchy combination method.
# If you only want to output the results for the joint tests (ignore the marginal tests), use --joint-only.






source /home/student/miniconda3/bin/activate regenie_env
regenie \
  --step 2 \
  --bed /home/student/USER/GWAS/data/European_1w_linear \
  --ref-first \
  --phenoFile /home/student/USER/GWAS/data/phenotype.txt \
  --strict \
  --bsize 200 \
  --apply-rint \
  --pred ./output/regenie_step1_pred.list \
  --check-burden-files \
  --anno-file /home/student/USER/GWAS/data/anno_file.txt \
  --set-list /home/student/USER/GWAS/data/set_list.txt \
  --mask-def /home/student/USER/GWAS/data/mask_file.txt \
  --skip-test \
  --strict-check-burden \
  --out ./output/burden_check
conda deactivate


source /home/student/miniconda3/bin/activate regenie_env
regenie \
  --step 2 \
  --bed /home/student/USER/GWAS/data/European_1w_linear \
  --ref-first \
  --phenoFile /home/student/USER/GWAS/data/phenotype.txt \
  --strict \
  --bsize 1000 \
  --apply-rint \
  --pred ./output/regenie_step1_pred.list \
  --anno-file /home/student/USER/GWAS/data/anno_file.txt \
  --set-list /home/student/USER/GWAS/data/set_list.txt \
  --mask-def /home/student/USER/GWAS/data/mask_file.txt \
  --aaf-bins 0.1,0.05 \
  --rgc-gene-p \
  --vc-tests skato,acato-full \
  --joint acat,sbat \
  --vc-MACthr 10 \
  --write-mask \
  --out ./output/gene_based_testing
conda deactivate
