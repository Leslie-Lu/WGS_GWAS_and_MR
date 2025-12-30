#!/bin/bash
set -euo pipefail
###############################################################################################
# PROJECT NAME          : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep.sh
# DESCRIPTION           : Gene-based testing
# DATE CREATED          : 2025-09-03
# INSPIRED BY           : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p014_regenie_euro_cin3plus.sh
# INPUT                 : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p024_gene_based_testing/file_locations.txt
# AUTHOR                : Zhen Lu
################################################################################################
# DATE MODIFIED         : 2025-09-03
# REASON                : Initial version
################################################################################################

output_dir_all="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/testing_results/all"
if [ ! -d "$output_dir_all" ]; then
  mkdir -p "$output_dir_all"
  echo "This directory does not exist, creating now..."
else
  echo "This directory already exists."
fi
output_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/testing_results"


# combine the regenie results by chromosomes, and only keep GENE_P rows
# You can override which TEST to keep, e.g.:
#   WANTED_TEST_REGEX='^(GENE_P|GENE_P_LoF)$' bash p024_gbt_all.sh
WANTED_TEST_REGEX="${WANTED_TEST_REGEX:-^GENE_P$}"

shopt -s nullglob
files=("${output_dir}"/step2_gb_euro_cin3plus_chr*.regenie)
if (( ${#files[@]} == 0 )); then
  echo "No input .regenie files found under: ${output_dir}" >&2
  exit 1
fi

mapfile -t files_sorted < <(printf '%s\n' "${files[@]}" | sort -V)

awk -v wanted_re="${WANTED_TEST_REGEX}" '
  BEGIN { FS="[ \t]+" }
  FNR==1 && NR==1 { print; next }
  FNR==2 && NR==2 {
    for (i=1; i<=NF; i++) if ($i=="TEST") test_col=i
    if (test_col==0) {
      print "ERROR: Could not find TEST column in header" > "/dev/stderr"
      exit 2
    }
    print
    next
  }
  FNR<=2 { next }
  $test_col ~ wanted_re { print }
' "${files_sorted[@]}" > "${output_dir_all}/WGS_gene_based_testing_all.regenie"
