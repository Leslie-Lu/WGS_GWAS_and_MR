#!/bin/bash
set -e
###############################################################################################
# PROJECT NAME          : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p015_annotation.sh
# DESCRIPTION           : Count unique variant-gene mappings in variantsMap2Genes.txt
# DATE CREATED          : 2025-08-18
# AUTHOR                : Zhen Lu
################################################################################################
# DATE MODIFIED         : 2025-08-18
# REASON                : Initial creation
################################################################################################

# OUTPUTDIR="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2"

# echo "=== Checking SNP uniqueness in variantsMap2Genes.txt ==="

# total_lines=$(wc -l < "${OUTPUTDIR}/variantsMap2Genes.txt")
# echo "Total lines in original file: $total_lines"

# unique_lines_count=$(sort "${OUTPUTDIR}/variantsMap2Genes.txt" | uniq | wc -l)
# echo "Unique complete lines: $unique_lines_count"
# unique_snp_count=$(awk 'NF >= 1 && $1 != "" {print $1}' "${OUTPUTDIR}/variantsMap2Genes.txt" \
#                    | sort | uniq | wc -l)
# echo "Unique SNPs in first column: $unique_snp_count"

# if [[ $unique_lines_count -eq $total_lines ]]; then
#   echo "All lines are unique. Original file is fine."
#   echo "No deduplication needed."
# else
#   echo "Found $((total_lines - unique_lines_count)) duplicate lines."
#   echo "Creating deduplicated file variantsMap2Genes_v2.txt"

#   sort "${OUTPUTDIR}/variantsMap2Genes.txt" \
#     | uniq > "${OUTPUTDIR}/variantsMap2Genes_v2.txt"
  
#   deduplicated_lines=$(wc -l < "${OUTPUTDIR}/variantsMap2Genes_v2.txt")
#   echo "Deduplicated file created with $deduplicated_lines lines."

#   removed_lines=$((total_lines - deduplicated_lines))
#   echo "Removed $removed_lines duplicate lines."
# fi

# echo "Finding duplicate lines..."
# sort "${OUTPUTDIR}/variantsMap2Genes.txt" | uniq -d > "${OUTPUTDIR}/duplicate_lines.txt"
# echo "Analyzing duplicate patterns..."
# sort "${OUTPUTDIR}/variantsMap2Genes.txt" | uniq -c > "${OUTPUTDIR}/line_counts.txt"
# awk '$1 > 1 {print}' "${OUTPUTDIR}/line_counts.txt" > "${OUTPUTDIR}/duplicate_lines_with_counts.txt"

# # 20250821
# wc -l < /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/duplicate_lines.txt
# awk 'NF >= 1 && $1 != "" {print $1, $2}' "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/duplicate_lines.txt" \
#   | sort | uniq | wc -l
# awk 'NF >= 1 && $1 != "" {print $1, $3}' "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/duplicate_lines.txt" \
#   | sort | uniq | wc -l
# wc -l < /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v2.regenie
# awk -F',' 'NF >= 1 && $1 != "" {print $3}' "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v2.regenie" \
#   | sort | uniq | wc -l

# 20250826
GWAS_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v3.regenie"
ANNOTATION_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/variantsMap2Genes_v2.txt"
OUTPUT_DIR="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2"

awk -F',' 'NR>1{print $3}' "$GWAS_FILE" | sort | uniq > "$OUTPUT_DIR/gwas_snps.txt"
unique_lines_count=$(wc -l < "${OUTPUT_DIR}/gwas_snps.txt")
echo "Number of unique SNPs in gwas_data: $unique_lines_count"
awk -F'\t' 'NR==FNR{keep[$1]=1;next} ($1 in keep)' \
  "$OUTPUT_DIR/gwas_snps.txt" "$ANNOTATION_FILE" > "$OUTPUT_DIR/variantsMap2Genes_v3_for_gwas.txt"
variantsMap2Genes_v3_lines=$(wc -l < "${OUTPUT_DIR}/variantsMap2Genes_v3_for_gwas.txt")
echo "Number of lines in variantsMap2Genes_v3_for_gwas.txt: $variantsMap2Genes_v3_lines"
head -n 5 "$OUTPUT_DIR/variantsMap2Genes_v3_for_gwas.txt"

awk -v anno_file="$OUTPUT_DIR/variantsMap2Genes_v3_for_gwas.txt" -v OFS="," '
BEGIN {
    FS_ANN  = "\t";
    FS_GWAS = ",";
    US  = "\034";
    RS2 = "\035"; 

    print "Loading annotation data..." > "/dev/stderr"
    k=1; r=2; g=3
    while ((getline line < anno_file) > 0) {
        split(line, fields, FS_ANN)
        key = fields[k]
        if (key == "" ) continue

        rs = (r && fields[r] != "" ? fields[r] : ".")
        ge  = (g && fields[g] != "" ? fields[g] : ".")

        map[key] = (key in map ? map[key] RS2 : "") rs US ge
    }
    close(anno_file)
    
    print "Loaded annotations for " length(map) " SNP keys" > "/dev/stderr"
}

FNR == 1 {
    FS = FS_GWAS
    print $0, "ANNO_RSID", "ANNO_GENE"
    next
}
{
    gwas_snp = $3
    if (gwas_snp in map) {
        n_matches = split(map[gwas_snp], rows, RS2)
        for (i = 1; i <= n_matches; i++) {
            split(rows[i], pair, US)  
            rsid = (pair[1] != "" ? pair[1] : ".")
            gene = (pair[2] != "" ? pair[2] : ".")
            print $0, rsid, gene
        }
    } else {
        print $0, ".", "."
    }
}' "$GWAS_FILE" > "$OUTPUT_DIR/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie"
awk -F',' '
NR>1 { c[$3]++ } 
END {
    for(k in c) {
        if(c[k] > 1) {
            print k, c[k]
            n++
        }
    }
    print "multi-mapped:", n+0
}' \
  "$OUTPUT_DIR/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie" > "$OUTPUT_DIR/multi_mapped_snps.txt"
anno_lines=$(wc -l < "$OUTPUT_DIR/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie")
echo "Dimensions of anno_gwas_data: $anno_lines"

echo "Looking for multi-mapped SNPs..."
awk -F',' 'NR>1{s[$3]++} END{for(k in s) if(s[k]>1) print k}' \
  "$OUTPUT_DIR/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie" \
| sort | uniq > "$OUTPUT_DIR/multi_snps.list"
awk -F'\t' 'NR==FNR{s[$1]; next} {if($1 in s) print}' \
  "$OUTPUT_DIR/multi_snps.list" \
  "$OUTPUT_DIR/variantsMap2Genes_v3_for_gwas.txt" \
> "$OUTPUT_DIR/multi_mapped_rows.txt"
