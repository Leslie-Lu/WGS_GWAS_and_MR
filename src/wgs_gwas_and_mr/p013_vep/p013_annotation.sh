#!/bin/bash
set -e
###############################################################################################
# PROJECT NAME          : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p013_vep/p013_annotation.sh
# DESCRIPTION           : Extract information from the annotated VCFs using bcftools
# DATE CREATED          : 2025-07-11
# INSPIRED BY           : https://samtools.github.io/bcftools/bcftools.html#concat
#                         https://samtools.github.io/bcftools/howtos/plugin.split-vep.html
#                         https://samtools.github.io/hts-specs/VCFv4.2.pdf
# bcftools VERSION      : 1.22
# AUTHOR                : Zhen Lu
################################################################################################
# DATE MODIFIED         : 2025-08-06
# REASON                : Fix the annotation error
################################################################################################

source /share/home/lsy_luzhen/software/miniconda3/bin/activate bcftools

output_dir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2"
mkdir -p "$output_dir"
vcf=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/allAnnotatedChrs.vcf.gz
ref_fasta=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

# # Step 1:
# bcftools query -f '%CHROM\n' "$vcf" | sort -u > "$output_dir/vcf_chroms.txt"
# samtools faidx "$ref_fasta" | cut -f1 | sort -u > "$output_dir/ref_chroms.txt"
# comm -3 "$output_dir/vcf_chroms.txt" "$output_dir/ref_chroms.txt" \
#   | sed 's/^\t/<only-in-ref>\t/' \
#   | sed 's/^/<only-in-vcf>\t/'

# # Step 2:
# remap=/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/rename_map.txt
# echo "--------Processing VCF annotation extraction--------"
# echo "1a. Renaming chromosomes in VCF to match reference genome..."
# bcftools annotate --rename-chrs "$remap" \
#   "$vcf" -Oz -o "${output_dir}/renamed.vcf.gz" --threads 64
# bcftools index "${output_dir}/renamed.vcf.gz" --threads 64

# echo "1b. Splitting multi-allelic sites..."
# bcftools norm -m -any -f "$ref_fasta" \
#   -Oz -o "${output_dir}/split.vcf.gz" "${output_dir}/renamed.vcf.gz" --threads 64
# bcftools index -f "${output_dir}/split.vcf.gz" --threads 64

echo "1c. Adding old rsIDs to INFO field..."
bcftools view -h "${output_dir}/split.vcf.gz" | \
  sed '0,/^##INFO=/{/^##INFO=/a ##INFO=<ID=OLD_RS,Number=1,Type=String,Description="Original rsID">
}' > "${output_dir}/map_header.vcf"
bcftools query -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t.\t.\tOLD_RS=%ID\n' \
  "${output_dir}/split.vcf.gz" \
  | sort -k1,1 -k2,2n >> "${output_dir}/map_header.vcf"
bgzip -c "${output_dir}/map_header.vcf" > "${output_dir}/map.vcf.gz"
bcftools index -f "${output_dir}/map.vcf.gz" --threads 64
bcftools annotate \
  -a "${output_dir}/map.vcf.gz" \
  -c CHROM,POS,REF,ALT,INFO/OLD_RS \
  -Oz -o "${output_dir}/tmp_with_old.vcf.gz" \
  "${output_dir}/split.vcf.gz" --threads 64
bcftools index -f "${output_dir}/tmp_with_old.vcf.gz" --threads 64

echo "2. Setting variant IDs to CHROM:POS:REF:ALT format..."
bcftools annotate \
  --set-id '%CHROM:%POS:%REF:%ALT' \
  -Oz -o "${output_dir}/all_chrposrefalt.vcf.gz" \
  "${output_dir}/tmp_with_old.vcf.gz" --threads 64
bcftools index -f "${output_dir}/all_chrposrefalt.vcf.gz" --threads 64

# Step 3:
echo "3. Extracting VEP annotations..."
bcftools +split-vep "${output_dir}/all_chrposrefalt.vcf.gz" \
  -f '%CHROM %POS %ID %INFO/OLD_RS %Existing_variation %SYMBOL %Gene %NEAREST %IMPACT %Consequence\n' \
  -d > "${output_dir}/allAnnotatedChrsInfo.tsv"
conda deactivate
echo "--------done"
