###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p015_annotation.r
# DESCRIPTION       : To define functional annotations for variants.
# DATE CREATED      : 2025-06-03
# INSPIRED BY       : /share/home/lsy_liuyanhong/20221125_metaGWAS/20230902_ICP/bin/add_info_to_meta_results.R
#                     /share/home/lsy_guyuqin/meta_analysis/phemap_220108/bin/add_annotation_info_to_meta_results.R
#                     https://asia.ensembl.org/info/genome/variation/prediction/predicted_data.html
# INPUT             : 
# OUTPUT            : 
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-08-07
# REASON            : Fix the annotation error
################################################################################################

# awk \
#     'NR==FNR{keep[$1]=1; next} ($3 in keep) {print}' \
#     /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis/CIN3plus_condition_list_all_lead_snps.txt \
#     /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/allAnnotatedChrsInfo.tsv \
#     > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/MR/proteomic_only_cis/cis_pqtls/haplotype_analysis/output/condition_analysis/condition_annotated_info_20251214.txt

# # 20260122
# awk \
#     'NR==FNR{keep[$1]=1; next} ($3 in keep) {print}' \
#     /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/cin3plus_GCTA_mht_lead_SNP_to_annotate.txt \
#     /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/allAnnotatedChrsInfo.tsv \
#     > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/cin3plus_GCTA_mht_lead_SNP_annotated_info_20260122.txt

# 20260208
awk \
    'NR==FNR{keep[$1]=1; next} ($3 in keep) {print}' \
    /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/cin3plus_GCTA_mht_lead_SNP_to_annotate_20260208.txt \
    /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/allAnnotatedChrsInfo.tsv \
    > /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/cin3plus_GCTA_mht_lead_SNP_annotated_info_20260208.txt
