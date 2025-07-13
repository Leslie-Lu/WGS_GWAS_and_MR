#!/bin/bash
set -e
###############################################################################################
# PROJECT NAME          : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep/p013_annotation.sh
# DESCRIPTION           : Extract information from the annotated VCFs using bcftools
# DATE CREATED          : 2025-07-11
# INSPIRED BY           : https://samtools.github.io/bcftools/bcftools.html#concat
#                         https://samtools.github.io/bcftools/howtos/plugin.split-vep.html
# bcftools VERSION      : 1.22
# AUTHOR                : Zhen Lu
################################################################################################
# DATE MODIFIED         : 2025-07-11
# REASON                : Initial version
################################################################################################


source /share/home/lsy_luzhen/software/miniconda3/bin/activate bcftools
output_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/"
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
  echo "This directory does not exist, creating now..."
else
  echo "This directory already exists."
fi
echo "--------start"
echo "Extract information from the annotated VCFs..."
vcf=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/allAnnotatedChrs.vcf.gz
output_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results"
bcftools +split-vep "$vcf" \
  -f '%CHROM %POS %ID %Existing_variation %SYMBOL %Gene %NEAREST %IMPACT %Consequence\n' \
  -d -O z -o "${output_dir}/allAnnotatedChrs_info.gz"
conda deactivate
echo "--------done"
