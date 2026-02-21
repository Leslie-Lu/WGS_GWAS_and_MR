#!/usr/bin/env bash
set -euo pipefail

# =========================================================================
# locuszoom plot for GWAS results
# 
# Author: Zhen Lu
# Date: 2026-01-23
# Version: 0.1.0
# References: https://genome.sph.umich.edu/wiki/LocusZoom_Standalone
# =========================================================================



outputdir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/locuszoom_output_v4"
mkdir -p "$outputdir"
mkdir -p "$outputdir/ld_files"
mkdir -p "$outputdir/figures_test1"
input="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v5_locus_20260124.regenie"
markers_file="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2"
source /share/home/lsy_luzhen/software/miniconda3/bin/activate py27
python --version
conda deactivate
conda deactivate
source /share/home/lsy_luzhen/software/miniconda3/bin/activate py27
python --version
pfile="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based/EuroPrePCA_ref38_rsID"
threads=$(nproc)

while IFS=',' read -r rsid refsnp chr bp; do
  from_bp=$((bp-500000))
  to_bp=$((bp+500000))
  output_prefix="$outputdir/ld_files/${chr}_${refsnp}_${from_bp}_${to_bp}"
  
  echo "Processing $refsnp (chr${chr}:${bp})..."

#   if [[ -f "${output_prefix}.vcf.gz" ]]; then
#     echo "  ✓ VCF already exist for $refsnp. Skipping to locuszoom..."
#   else
#     echo "  [1/3] Generating VCF for $refsnp..."
#     if ! plink2 --pfile "$pfile" \
#           --chr "$chr" \
#           --from-bp "$from_bp" \
#           --to-bp "$to_bp" \
#           --max-alleles 2 \
#           --export vcf bgz \
#           --threads $threads \
#           --out "$output_prefix"; then
#       echo "  ✗ Failed to generate VCF for $refsnp" >&2
#       continue
#     fi
#     echo "  ✓ VCF generated successfully"
#   fi

#   echo "  [1.5/3] Handling multiallelic variants for $refsnp..."
#     if [[ -f "${output_prefix}.biallelic_any.vcf.gz" ]]; then
#         echo "  ✓ Multiallelic variants handled successfully for $refsnp"
#     else
#         source /share/home/lsy_luzhen/software/miniconda3/bin/activate bcftools
#         bcftools norm -m -any \
#             "${output_prefix}.vcf.gz" \
#             | bcftools view -m2 -M2 \
#             -Oz -o "${output_prefix}.biallelic_any.vcf.gz"
#         echo "  ✓ Multiallelic variants handled successfully for $refsnp"
#     fi

#   ehco "  [1.6/3] Check if $rsid exists in the VCF for $refsnp..."
#     if bcftools view -H "${output_prefix}.biallelic_any.vcf.gz" \
#         | awk -F'\t' '$3=="'"$rsid"'"{print; found=1} END{exit !found}'; then
#         echo "✓ Found $rsid in VCF file"
#     else
#         echo "✗ $rsid not found in VCF file"
#     fi

#   if [[ -f "${output_prefix}.biallelic_any.vcf.gz.tbi" ]]; then
#     echo "  ✓ VCF index already exist for $refsnp. Skipping to locuszoom..."
#   else
#     echo "  [2/3] Indexing VCF for $refsnp..."
#     source /share/home/lsy_luzhen/software/miniconda3/bin/activate bcftools
#     if bcftools index -t -f "${output_prefix}.biallelic_any.vcf.gz" --threads ${threads}; then
#                 echo "✓ VCF sorted and indexed successfully for $refsnp"
#             else
#                 echo "✗ Failed to index VCF for $refsnp" >&2
#                 conda deactivate
#                 continue
#             fi
#     conda deactivate
#     source /share/home/lsy_luzhen/software/miniconda3/bin/activate py27
#   fi
  
  echo "  [3/3] Running locuszoom for $refsnp..."
  if /share/home/lsy_luzhen/software/locuszoom/locuszoom/bin/locuszoom \
        --metal "$input" \
        --markercol ANNO_RSID_v2 \
        --pvalcol P \
        --refsnp "$rsid" \
        --add-refsnps "$refsnp" \
        --denote-markers-file "$markers_file/markers_file_lead_snps_${chr}_${from_bp}_${to_bp}_20260124.txt" \
        --start "$from_bp" \
        --end "$to_bp" \
        --chr "$chr" \
        --flank 500kb \
        --pop EUR \
        --build hg38 \
        --source 1000G_Nov2014 \
        --prefix "$outputdir/figures_test1/locuszoom_${refsnp}"; then
    echo "✓ Successfully processed $refsnp"
  else
    echo "✗ Failed to run locuszoom for $refsnp" >&2
  fi
done << EOF
rs4849179,rs5833488,2,113231545
rs2523496,rs6938453,6,31410016
rs117905563,rs117905563,8,128617170
EOF

conda deactivate
