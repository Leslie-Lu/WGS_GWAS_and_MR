#!/bin/bash
#SBATCH --job-name=vep
#SBATCH --nodes=1 
#SBATCH --cpus-per-task=96    
#SBATCH --time=50-00:00:00
#SBATCH --mem=1160G
#SBATCH --partition=bigmem
#SBATCH --output=/dev/null

EXEC=/share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p015_annotation.R
SCRIPT_NAME=$(basename $EXEC .R)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
# # 20250826
# Rscript $EXEC
# bash /share/home/lsy_luzhen/WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p015_annotation.sh

# # 20250904
# OUTPUTDIR="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2"
# echo "Analyzing raw regenie results file..."
# wc -l < "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all.regenie"
# wc -l < "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v2.regenie"
# awk -F',' '{print $1}' "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v2.regenie" | sort | uniq -c
# awk -F',' '{split($3,a,":"); print a[1]}' "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v2.regenie" | sort | uniq -c
# echo "Annotating regenie results with VEP output..."
# wc -l < "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie"
# awk -F',' '{print $1}' "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie" | sort | uniq -c
# awk -F',' '{split($3,a,":"); print a[1]}' "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie" | sort | uniq -c
# echo "Filtering lines with '.' in the 16th column (gene name)..."
# awk -F',' '$16 != "."' "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie" > "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_FILTERED.regenie"
# wc -l < "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_FILTERED.regenie"
# echo "Lines with NA in annotation (column 16):"
# awk -F',' '$16 == "."' "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie" > "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_NA.regenie"
# wc -l < "${OUTPUTDIR}/WGS_regenie_step2_euro_cin3plus_all_v3_anno_NA.regenie"

# # 20250827
# OUTPUT_DIR1="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2"
# OUTPUT_DIR2="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/gene_based_testing"
# ANNOTATION_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/gene_based_testing/allAnnotatedChrs_info_used_v2.txt"
# annotation_file_count=$(wc -l < "$ANNOTATION_FILE")
# echo "Annotation file has $annotation_file_count lines."
# head -n 6 "$ANNOTATION_FILE"
# # awk -F'\t' 'NR==FNR{keep[$1]=1;next} ($3 in keep)' \
# #   "$OUTPUT_DIR1/gwas_snps.txt" "$ANNOTATION_FILE" > "$OUTPUT_DIR2/allAnnotatedChrs_info_used_v3_anno.txt"
# annotation_file_count_v3=$(wc -l < "$ANNOTATION_FILE")
# echo "Filtered annotation file has $annotation_file_count_v3 lines."
# # head -n 6 "$OUTPUT_DIR2/allAnnotatedChrs_info_used_v3_anno.txt"

# 20250827
Rscript $EXEC

# 20250829
outputDir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based"
anno_file_lines=$(wc -l < "${outputDir}/anno_file.txt")
echo "Number of lines in anno_file.txt: $anno_file_lines"
head -n 5 "${outputDir}/anno_file.txt"
sort "${outputDir}/anno_file.txt" | uniq > "${outputDir}/anno_file_unique.txt"
unique_anno_file_lines=$(wc -l < "${outputDir}/anno_file_unique.txt")
echo "Number of unique lines in anno_file_unique.txt: $unique_anno_file_lines"

set_list_lines=$(wc -l < "${outputDir}/set_list.txt")
echo "Number of lines in set_list.txt: $set_list_lines"
# head -n 5 "${outputDir}/set_list.txt"
sort "${outputDir}/set_list.txt" | uniq > "${outputDir}/set_list_unique.txt"
unique_set_list_lines=$(wc -l < "${outputDir}/set_list_unique.txt")
echo "Number of unique lines in set_list_unique.txt: $unique_set_list_lines"

grep "A4GALT" "${outputDir}/set_list_unique.txt" \
 > "${outputDir}/A4GALT_in_set_list.txt"

# 20250830
outputDir="/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based"
na_gene_count=$(awk '$1 == "."' "${outputDir}/set_list_unique.txt" | wc -l)
echo "Number of lines with '.' as gene name: $na_gene_count"
awk '$1 != "."' "${outputDir}/set_list_unique.txt" > "${outputDir}/set_list_unique_filtered.txt"
awk '$1 == "."' "${outputDir}/set_list_unique.txt" > "${outputDir}/set_list_unique_na.txt"

na_gene_count_for_anno=$(awk '$2 == "."' "${outputDir}/anno_file_unique.txt" | wc -l)
echo "Number of lines with '.' as gene name in annotation file: $na_gene_count_for_anno"
awk '$2 != "."' "${outputDir}/anno_file_unique.txt" > "${outputDir}/anno_file_unique_filtered.txt"
awk '$2 == "."' "${outputDir}/anno_file_unique.txt" > "${outputDir}/anno_file_unique_na.txt"

head -n 1 "${outputDir}/set_list_unique_na.txt" > "${outputDir}/set_list_unique_na_head.txt"
head -n 1 "${outputDir}/anno_file_unique_na.txt" > "${outputDir}/anno_file_unique_na_head.txt"
grep -o "," "${outputDir}/set_list_unique_na.txt" | wc -l

wc -l < "${outputDir}/set_list_unique_filtered.txt"
awk '{print $2, $1}' "${outputDir}/set_list_unique_filtered.txt" | sort | uniq | awk '{print $1}' | sort | uniq -c | sort -nr

# 20250831
awk -F'\t' '$1 ~ /^X:/{print $3}' "${outputDir}/anno_file_unique_filtered.txt" | wc -l
awk -F'\t' '$1 ~ /^X:/{print $3}' "${outputDir}/anno_file_unique_filtered.txt" | sort | uniq -c | sort -nr
# 20250901
awk '{split($1,a,":"); print a[1]}' "${outputDir}/anno_file_unique_filtered.txt" | sort | uniq -c | sort -nr
echo 'end at:'
date
