#!/bin/bash
set -e
###############################################################################################
# PROJECT NAME          : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep/p013_vep_All.sh
# DESCRIPTION           : Concatenate all annotated VCFs
# DATE CREATED          : 2025-07-11
# INSPIRED BY           : /share/home/lsy_yangzijing/vep/bin/
#                         https://samtools.github.io/bcftools/bcftools.html#concat
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
vcf_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/VEP_annotated_vcfs"
output_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results"
for vcf_file in "${vcf_dir}/chr"*"_annotated.vcf.gz"
do
  echo "Indexing ${vcf_file}..."
  bcftools index -f "${vcf_file}" --threads 32
done
echo "Concatenating and indexing all annotated VCFs..."
ls "${vcf_dir}/chr"*"_annotated.vcf.gz" |
  sort -V > "${output_dir}/annotated_vcfs.txt" && \
  bcftools concat -f "${output_dir}/annotated_vcfs.txt" \
  -o "${output_dir}/allAnnotatedChrs.vcf.gz" -O z --threads 32 && \
  bcftools index "${output_dir}/allAnnotatedChrs.vcf.gz" --threads 32
conda deactivate
echo "--------done"
