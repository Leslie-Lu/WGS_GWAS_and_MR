#!/bin/bash
###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p007_QC_european.sh
# DESCRIPTION       : QC for European ancestry individuals on DNAnexus platform and/or local
# DATE CREATED      : 2025-04-18
# INSPIRED BY       : https://documentation.dnanexus.com/user/helpstrings-of-sdk-command-line-utilities#run
#                   : https://documentation.dnanexus.com/user/running-apps-and-workflows/running-apps-and-applets
#                   : https://platform.dnanexus.com/app/swiss-army-knife
#                   : https://cloufield.github.io/GWASTutorial/04_Data_QC/#plink-syntax
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-05-12
# REASON            : Update the --mind from 0.05 to 0.2 for the sample missing rate
################################################################################################

# # 1. keep only European ancestry individuals on local
# # merge all snp microarray data (ssh)
# threads=$(nproc)
# plink --make-bed \
#   --merge-list /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/chr_merge_list_sorted2.txt \
#   --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/merged_snp_microarray \
#   --threads $threads
# # keep only European ancestry individuals (ssh)
# threads=$(nproc)
# plink --make-bed \
#   --bfile /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/merged_snp_microarray \
#   --keep /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/D007EligibleCasesandControlsID_european.txt \
#   --out /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/snp_microarray_european \
#   --threads $threads

# # 2. QC for European ancestry individuals on local
# threads=$(nproc)
# genotypeFile="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/snp_microarray_european"
# output_path="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/QC_european"

# # Missing rate (call rate)
# plink \
#   --bfile ${genotypeFile} \
#   --missing \
#   --threads $threads \
#   --out "$output_path/plink_results_missing_rate"
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p008_genotype_data_qc.ipynb
# # Allele frequency
# plink \
#   --bfile ${genotypeFile} \
#   --freq \
#   --out "$output_path/plink_result_allele_freq" \
#   --threads $threads
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p008_genotype_data_qc.ipynb
# # Hardy-Weinberg equilibrium exact test
# plink \
#   --bfile ${genotypeFile} \
#   --hardy \
#   --out "$output_path/plink_result_hwe" \
#   --threads $threads
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p008_genotype_data_qc.ipynb

# # LD pruning
# plink \
#   --bfile ${genotypeFile} \
#   --maf 0.001 \
#   --geno 0.05 \
#   --mind 0.2 \
#   --hwe 1e-6 \
#   --indep-pairwise 50 5 0.2 \
#   --out "$output_path/plink_result_ld_pruning" \
#   --threads $threads

# # Inbreeding F coefficient
# plink \
#   --bfile ${genotypeFile} \
#   --extract "$output_path/plink_result_ld_pruning.prune.in" \
#   --het \
#   --out "$output_path/plink_result_inbreeding" \
#   --threads $threads
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p008_genotype_data_qc.ipynb
# awk 'NR>1 && $6>0.0201 || $6<-0.0231 {print $1,$2}' \
#   "$output_path/plink_result_inbreeding.het" > "$output_path/high_het.sample"

# # Apply all the filters to obtain a clean dataset
# plink \
#   --bfile ${genotypeFile} \
#   --maf 0.001 \
#   --geno 0.05 \
#   --mind 0.2 \
#   --hwe 1e-6 \
#   --indep-pairwise 50 5 0.2 \
#   --remove "$output_path/high_het.sample" \
#   --keep-allele-order \
#   --make-bed \
#   --out "$output_path/european_data_pass_qc" \
#   --threads $threads

# # 3. pre-PCA
# threads=$(nproc)
# genotypeFile="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/QC_european/european_data_pass_qc"
# output_path="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european"

# # Create a list of SNPs in high-LD or HLA regions
# plink \
#   --bfile ${genotypeFile} \
#   --make-set /share/home/lsy_luzhen/WGS_GWAS_and_MR/output/high-ld-hg19.txt \
#   --write-set \
#   --out "$output_path/hild" \
#   --threads $threads

# # LD-pruning, excluding high-LD and HLA regions
# plink2 \
#   --bfile ${genotypeFile} \
#   --maf 0.001 \
#   --exclude "$output_path/hild.set" \
#   --indep-pairwise 500 50 0.2 \
#   --out "$output_path/european_ld_pruning" \
#   --threads $threads

# # remove related samples using king-cutoff
# plink2 \
#   --bfile ${genotypeFile} \
#   --extract "$output_path/european_ld_pruning.prune.in" \
#   --king-cutoff 0.0884 \
#   --out "$output_path/european_king_cutoff" \
#   --threads $threads

# # obtain a clean pre-PCA dataset
# plink \
#   --bfile ${genotypeFile} \
#   --keep "$output_path/european_king_cutoff.king.cutoff.in.id" \
#   --extract "$output_path/european_ld_pruning.prune.in" \
#   --keep-allele-order \
#   --make-bed \
#   --out "$output_path/european_pre_pca_data" \
#   --threads $threads
# # Apr 21:            260007 variants and 195468 people pass filters and QC.
# # Updated on May 13: 259839 variants and 203972 people pass filters and QC.

# # output eligible pre-pca european sample id
# awk 'NR>1 {print $1, $2}' "$output_path/european_king_cutoff.king.cutoff.in.id" > \
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T001_EuropeanPrePCAID.txt"


# # 4. pre-PCA
# # run WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p009_european_pre_pca.r
# # recode phenotype values (eligible_cc_cin3) in .fam
# awk '{print $1, $4+1}' \
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome.txt" > \
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome_recode_cc_cin3.txt"
# awk '{count[$4]++} END {for (value in count) print value, count[value]}' \
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome.txt"
# awk '{count[$2]++} END {for (value in count) print value, count[value]}' \
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome_recode_cc_cin3.txt"
# # replace the 6th column of .fam with the recoded phenotype values
# awk 'NR==FNR {a[$1]=$2; next} {print $1,$2,$3,$4,$5,a[$1]}' \
#   "/share/home/lsy_luzhen/WGS_GWAS_and_MR/output/T002_EuropeanPrePCA_outcome_recode_cc_cin3.txt" \
#   "$output_path/european_pre_pca_data.fam" > \
#   "$output_path/european_pre_pca_data_outcome_cc_cin3.fam"
# awk '{count[$6]++} END {for (value in count) print value, count[value]}' \
#   "$output_path/european_pre_pca_data_outcome_cc_cin3.fam"
# cp "$output_path/european_pre_pca_data.bed" \
#   "$output_path/european_pre_pca_data_outcome_cc_cin3.bed"
# cp "$output_path/european_pre_pca_data.bim" \
#   "$output_path/european_pre_pca_data_outcome_cc_cin3.bim"
