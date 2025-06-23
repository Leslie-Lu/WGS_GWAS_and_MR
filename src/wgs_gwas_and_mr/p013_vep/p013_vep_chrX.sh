#!/bin/bash
###############################################################################################
# PROJECT NAME          : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep.sh
# DESCRIPTION           : Run VEP for gene annotation
# DATE CREATED          : 2025-06-22
# INSPIRED BY           : /share/home/lsy_yangzijing/vep/bin/
#                         https://www.ensembl.org/info/docs/tools/vep/script/vep_cache.html#cache
#                         https://www.ensembl.org/info/docs/tools/vep/script/vep_options.html#basic
# INPUT                 : 
# ensembl-vep VERSION   : 114.1
# AUTHOR                : Zhen Lu
################################################################################################
# DATE MODIFIED         : 2025-06-22
# REASON                : Initial version
################################################################################################

# VEP in local
source /share/home/lsy_luzhen/software/miniconda3/bin/activate test
output_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/"
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
  echo "This directory does not exist, creating now..."
else
  echo "This directory already exists."
fi
echo "--------start"
vep --input_file /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/VEP_concat_vcfs/chrX_concat.vcf.gz \
  --format vcf \
  --output_file /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/VEP_annotated_vcfs/chrX_annotated.vcf.gz \
  --force_overwrite \
  --fork 16 \
  --cache --dir /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/ \
  --species homo_sapiens \
  --offline \
  --cache_version 114 \
  --vcf \
  --compress_output bgzip \
  --fasta /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz \
  --hgvs \
  --symbol \
  --af \
  --af_1kg \
  --pick \
  --nearest symbol \
  --gene_phenotype \
  --regulatory
echo "--------done"




