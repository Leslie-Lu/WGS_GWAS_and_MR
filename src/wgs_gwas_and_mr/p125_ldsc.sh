#!/usr/bin/env bash
set -euo pipefail

# =========================================================================
# ldsc
# 
# Author: Zhen Lu
# Date: 2026-01-04
# Version: 0.1.0
# References: https://zenodo.org/records/8182036
#             https://github.com/bulik/ldsc
# =========================================================================

# #########################################################################
# --- 1. munge data ---
# #########################################################################

# LDSC_ENV="/share/home/lsy_luzhen/software/miniconda3/envs/ldsc"
# LDSC_MUNGE="${LDSC_ENV} /share/home/lsy_luzhen/software/ldsc/munge_sumstats.py"
# LDSC="${LDSC_ENV} /share/home/lsy_luzhen/software/ldsc/ldsc.py"
LDSC_ENV="/share/home/lsy_luzhen/software/miniconda3/envs/ldsc"
PY="${LDSC_ENV}/bin/python"
MUNGE="/share/home/lsy_luzhen/software/ldsc/munge_sumstats.py"
LDSC="/share/home/lsy_luzhen/software/ldsc/ldsc.py"

snplist="/share/home/lsy_luzhen/software/ldsc/eur_w_ld_chr/w_hm3.snplist"
outputdir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/ldsc/output"
mkdir -p "$outputdir"

# # input="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie"
# tsv="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie.tsv"
# # awk 'BEGIN{FS=OFS=","} {for(i=1;i<=NF;i++) printf "%s%s", $i, (i==NF?ORS:OFS)}' "$input" | tr ',' '\t' > "$tsv"
# in="$tsv"
# out="${outputdir}/cin3plus_for_ldsc.tsv"

# awk -F'\t' 'BEGIN{OFS="\t"}
# NR==1{
#   for(i=1;i<=NF;i++) h[$i]=i
#   print "SNP","A1","A2","P","BETA","N","FRQ"
#   next
# }
# {
#   print $(h["ANNO_RSID"]), $(h["ALLELE1"]), $(h["ALLELE0"]), $(h["P"]), $(h["BETA"]), $(h["N"]), $(h["A1FREQ"])
# }' "$in" > "$out"
# head "$out"

# "$PY" "$MUNGE" \
#     --sumstats "$out" \
#     --merge-alleles "$snplist" \
#     --N-col N \
#     --out "${outputdir}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_munged" \
#     --maf-min 0.001 \
#     --snp ANNO_RSID \
#     --a1 ALLELE1 \
#     --a2 ALLELE0 \
#     --p P \
#     --frq A1FREQ \
#     --signed-sumstats BETA,0 \
#     --chunksize 500000

# "$PY" "$LDSC" \
#   --h2 "${outputdir}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_munged.sumstats.gz" \
#   --ref-ld-chr /share/home/lsy_luzhen/software/ldsc/eur_w_ld_chr/ \
#   --w-ld-chr /share/home/lsy_luzhen/software/ldsc/eur_w_ld_chr/ \
#   --out "${outputdir}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_munged_h2"

for pop_prev in 0.005 0.01 0.015 0.02; do
  "$PY" "$LDSC" \
    --h2 "${outputdir}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_munged.sumstats.gz" \
    --ref-ld-chr /share/home/lsy_luzhen/software/ldsc/eur_w_ld_chr/ \
    --w-ld-chr /share/home/lsy_luzhen/software/ldsc/eur_w_ld_chr/ \
    --out "${outputdir}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_munged_h2_${pop_prev}" \
    --samp-prev 0.02734689 \
    --pop-prev "$pop_prev"
done 

# --N-cas 5578 \
# --N-con 198394 \
# --samp-prev 0.02734689 \
# --pop-prev 
