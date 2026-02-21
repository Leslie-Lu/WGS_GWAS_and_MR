#!/usr/bin/env bash
set -euo pipefail

# =========================================================================
# Conditional association analysis on HLA alleles
# 
# Author: Zhen Lu
# Date: 2025-12-31
# Version: 0.1.0
# References: /share/home/lsy_guoxinxin/project/14-5project/condition/hped
#             https://www.cog-genomics.org/plink/2.0/input#import_dosage
# =========================================================================

# #########################################################################
# --- 1. tansform allele-level matrix ---
# #########################################################################

# matrix="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele/HLA_allele_dosage_final.traw"
# out_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele"
# threads=$(nproc)
# # awk 'NR==1{print "IID"; next} {print $1}' "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele/HLA_allele_dosage.txt" > "$out_dir/HLA_alleles_analysis.fam"
# time plink2 \
#     --import-dosage "$matrix" noheader skip0=1 skip1=2 chr-col-num=1 pos-col-num=4 ref-first \
#     --fam "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele/HLA_allele_dosage_final_v2.fam" \
#     --make-pgen \
#     --out "$out_dir/HLA_alleles" \
#     --threads $threads
# wait

# #########################################################################
# --- 2. Condition analysis ---
# #########################################################################

out_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele"
threads=$(nproc)
out_dir2="$out_dir/results"
mkdir -p "$out_dir2"
pheno_col_name=PHENO1

echo "No-conditional analysis start:"
round=0

pfile="$out_dir/HLA_alleles"
# pheno=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt
# awk 'NR==1{print "#IID\tCIN3plus"; next} {print $1"\t"$3}' \
#   /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype.txt \
#   > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype_20251211.txt
# pheno=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype_20251211.txt
# awk 'NR==1{print "#FID\tIID\tPHENO1"; next} {print $1"\t"$1"\t"$2+1}' \
#   /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype_20251211.txt \
#   > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype_20251231.txt
# awk '{count[$2]++} END {for (value in count) print value, count[value]}' \
#   /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype_20251231.txt
# pheno=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_phenotype_20251231.txt
pheno=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele/T002_CIN3plus_phenotype_20251231_v2.txt
# /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars.txt
# covar=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical.txt
# covar=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical_20251231.txt
# awk -F'\t' -v OFS='\t' '
# NR==1 {
#   printf "#IID"
#   for(i=3;i<=NF;i++) printf "%s%s", OFS, $i
#   print ""
#   next
# }
# {
#   printf "%s", $2
#   for(i=3;i<=NF;i++) printf "%s%s", OFS, $i
#   print ""
# }
# ' /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical.txt \
# > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical_20251211.txt
# awk -F'\t' -v OFS='\t' '
# NR==1 {
#   printf "#IID"
#   for(i=3;i<=NF;i++) printf "%s%s", OFS, $i
#   print ""
#   next
# }
# {
#   printf "%s", $2
#   for(i=3;i<=NF;i++) printf "%s%s", OFS, $i
#   print ""
# }
# ' /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical_20251231.txt \
# > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical_20251231_V2.txt
covar=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/T002_CIN3plus_covars_categorical_20251231.txt
condition=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis_HLA_allele/empty.txt

# generate condition analysis script
cat > ${out_dir}/${pheno_col_name}_condition_analysis_HLA_alleles.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

pfile="$1"
pheno="$2"
pheno_col_name="$3"
covar="$4"
out_dir="$5"
round="$6"
condition="$7"

threads=$(nproc)

time plink2 \
  --pfile "$pfile" \
  --ci 0.95 \
  --pheno "$pheno" \
  --pheno-name "$pheno_col_name" \
  --covar "$covar" \
  --covar-variance-standardize \
  --glm no-x-sex hide-covar cols=+a1freq,+a1count omit-ref \
  --out "$out_dir/${pheno_col_name}_condition_r${round}_HLA_alleles" \
  --condition-list "$condition" \
  --threads "$threads"
wait
EOF

chmod +x ${out_dir}/${pheno_col_name}_condition_analysis_HLA_alleles.sh

# round 0
sh ${out_dir}/${pheno_col_name}_condition_analysis_HLA_alleles.sh \
  $pfile \
  $pheno \
  $pheno_col_name \
  $covar \
  $out_dir2 \
  $round \
  $condition

# exclude multiallelic variants: (Error: --condition[-list] 'multiallelic' implementation is under development for plink2.)
awk -F'\t' 'BEGIN{OFS="\t"} $0 !~ /^#/ && $5 !~ /,/ {print $3}' \
  "$out_dir/HLA_alleles.pvar" \
  > ${out_dir2}/biallelic_ids.txt
# extract significant SNPs (P < 5e-8)
awk \
    -F'\t' \
    'NR==FNR { keep[$1]=1; next } NR!=FNR && FNR==1 { next } (($3 in keep) && $19!="NA" && $19!="nan" && $19+0==$19 && $19<=5e-8){print}' \
    ${out_dir2}/biallelic_ids.txt $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles.${pheno_col_name}.glm.logistic.hybrid \
    | sort -t$'\t' -k19,19g \
    > $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort

# select the most significant SNP as lead SNP
condition="$out_dir2/${pheno_col_name}_condition_list_all_lead_snps.txt"
: > "$condition"
awk 'NR==1{print $3; found=1} END{if(!found) exit 1}' \
    $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort \
    >> "$condition" \
  || echo "No genome-wide significant SNP found in round ${round}."
# count significant SNPs
sig_num=$(awk '{c++} END{print c+0}' $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort)
if [ "$sig_num" -eq 0 ]; then
  echo "No genome-wide significant SNP found in round ${round}."
fi
echo "No-conditional analysis finish"

# # skip run 0 and 1, directly go to round 2
# echo "Check round 1 analysis results:"
# round=1
# # extract significant SNPs (P < 5e-8)
# awk \
#     -F'\t' \
#     'NR==FNR { keep[$1]=1; next } NR!=FNR && FNR==1 { next } (($3 in keep) && $19!="NA" && $19!="nan" && $19+0==$19 && $19<=5e-8){print}' \
#     ${out_dir2}/biallelic_ids.txt $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles.${pheno_col_name}.glm.logistic.hybrid \
#     | sort -t$'\t' -k19,19g \
#     > $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort

# # select the most significant SNP as lead SNP
# awk 'NR==1{print $3; found=1} END{if(!found) exit 1}' \
#     $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort \
#     >> "$condition" \
#   || echo "No genome-wide significant SNP found in round ${round}."
# # count significant SNPs
# sig_num=$(awk '{c++} END{print c+0}' $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort)
# if [ "$sig_num" -eq 0 ]; then
#   echo "No genome-wide significant SNP found in round ${round}."
# fi
# echo "Round 1 analysis check finish"

# iterative conditional analysis
echo "Iterative conditional analysis start:"
while [ "${sig_num}" -gt 0 ]
do
    round=$((round+1))
  
    echo "Round${round} begins:"
    echo "Significant SNPs number before condition analysis: ${sig_num}"
    echo "The lead SNP(s) from last round is/are in file: ${condition}"
    echo "----------------------------------------"
    cat ${condition} || echo "No lead SNP file found."
    echo "----------------------------------------"
  
    echo "Running condition analysis for round ${round}..."
    sh ${out_dir}/${pheno_col_name}_condition_analysis_HLA_alleles.sh \
        $pfile \
        $pheno \
        $pheno_col_name \
        $covar \
        $out_dir2 \
        $round \
        $condition
    echo "Condition analysis for round ${round} completed."

    echo "Extracting significant SNPs for round ${round}..."

    # extract significant SNPs (P < 5e-8)
    awk \
        -F'\t' \
        'NR==FNR { keep[$1]=1; next } NR!=FNR && FNR==1 { next } (($3 in keep) && $19!="NA" && $19!="nan" && $19+0==$19 && $19<=5e-8){print}' \
        ${out_dir2}/biallelic_ids.txt $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles.${pheno_col_name}.glm.logistic.hybrid \
        | sort -t$'\t' -k19,19g \
        > $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort
    
    # select the most significant SNP as lead SNP
    awk 'NR==1{print $3; found=1} END{if(!found) exit 1}' \
        $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort \
        >> "$condition" \
    || echo "No genome-wide significant SNP found in round ${round}."
    sort -u "$condition" -o "$condition"
    # count significant SNPs
    sig_num=$(awk '{c++} END{print c+0}' $out_dir2/${pheno_col_name}_condition_r${round}_HLA_alleles_sig_sort)
    if [ "$sig_num" -eq 0 ]; then
        echo "No genome-wide significant SNP found in round ${round}."
        break
    fi
    echo "Round${round} completed."
done
