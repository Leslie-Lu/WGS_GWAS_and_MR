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

rm(list = ls())
gc()

library(magrittr)
library(data.table)

# # --- Step 1. Read raw data ---
# inputFile1 = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/allAnnotatedChrsInfo.tsv"
# outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2"
# annotated_info= data.table::fread(
#   inputFile1,
#   header = FALSE,
#   col.names = c(
#     "CHR", "BP", "ID", "OLD_RS", "Existing_variation",
#     "SYMBOL", "Gene", "NEAREST",
#     "IMPACT", "Consequence"
#   )
# )
# annotated_info %>% head()
# annotated_info %>% dim()
# annotated_info[SYMBOL == "A4GALT", ] %>%
#   data.table::fwrite(file.path(outputDir, "A4GALT_annotated_info.txt"), sep = "\t", quote = FALSE)
# saveRDS(annotated_info,
#         file = file.path(outputDir, "allAnnotatedChrsInfo.rds"),
#         compress = "xz")

# # --- 2. Tidy vep data ---
# data.table::setDT(annotated_info)
# message("Number of NA in ID: ", sum(is.na(annotated_info$ID) | annotated_info$ID == "."))
# message("Number of NA in OLD_RS: ", sum(is.na(annotated_info$OLD_RS) | annotated_info$OLD_RS == "."))
# message("Number of NA in Existing_variation: ", sum(is.na(annotated_info$Existing_variation) | annotated_info$Existing_variation == "."))
# message("Number of . in ID: ", sum(annotated_info$ID == ".", na.rm = TRUE))
# message("Number of . in OLD_RS: ", sum(annotated_info$OLD_RS == ".", na.rm = TRUE))
# message("Number of . in Existing_variation: ", sum(annotated_info$Existing_variation == ".", na.rm = TRUE))
# annotated_info[
#   , `:=`(
#     OLD_RS= data.table::fifelse(
#       OLD_RS != "." & !is.na(OLD_RS),
#       OLD_RS,
#       Existing_variation,
#       "Error"
#     ),
#     Gene= NULL
#   )
# ] %>%
#   data.table::setnames(c("SYMBOL", "ID"), c("GENE", "SNP"))
# annotated_info %>% head()
# annotated_info %>% dim()

# used_info= annotated_info[, .(CHR, BP, SNP, OLD_RS, GENE, IMPACT, Consequence)]
# rm(annotated_info)
# used_info %>% head()
# used_info %>% dim()
# saveRDS(used_info,
#         file = file.path(outputDir, "allAnnotatedChrs_info_used.rds"))

# --- 3. format used_info ---
outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2"
used_info= readRDS(
  file = file.path(outputDir, "allAnnotatedChrs_info_used.rds")
)
data.table::setDT(used_info)
message("Unique chromosomes in used_info: ", paste(used_info$CHR %>% unique() %>% sort(), collapse = ", "))
used_info[,
  CHR := data.table::fifelse(CHR %in% c("X", "x"), "23", CHR, "Error")
][,
  CHR := data.table::fifelse(CHR %in% c("Y", "y"), "24", CHR, "Error")
]
message("Number of variants by chromosomes: ")
print(used_info[, .N, by = CHR])
message("Dimensions of used_info: ", paste(dim(used_info), collapse = ", "))
# --- 3b. debug ---
# tryCatch({
#   message("Number of unique SNPs in used_info: ", data.table::uniqueN(used_info, by = "SNP"))
# }, error = function(e) {
#   message("Error in counting unique SNPs in used_info: ", e$message)
# }, warning = function(w) {
#   message("Warning in counting unique SNPs in used_info: ", w$message)
# })
# variantsMap2Genes= used_info[, .(SNP)]
# tryCatch({
#   message("Number of unique SNPs in variantsMap2Genes: ", data.table::uniqueN(variantsMap2Genes, by = "SNP"))
# }, error = function(e) {
#   message("Error in counting unique SNPs in variantsMap2Genes: ", e$message)
# }, warning = function(w) {
#   message("Warning in counting unique SNPs in variantsMap2Genes: ", w$message)
# })
used_info[, .(SNP, OLD_RS, GENE)] %>%
  data.table::fwrite(
    file = file.path(outputDir, "variantsMap2Genes.txt"),
    sep = "\t",
    quote = FALSE,
    col.names = FALSE
  )
saveRDS(used_info,
        file = file.path(outputDir, "allAnnotatedChrs_info_used_v2.rds"))


# # 4. read gwas results
# used_info= readRDS("/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/allAnnotatedChrs_info_used_v2.rds")
# gwas_results= "/share/home/lsy_luzhen/summer_school_gwas_exercise_2025/data/input/regenie_step2_asso_W_PC20_phenotype_v2.regenie"
# maf_filter= 0
# gwas_data= data.table::fread(gwas_results)

# adjustedGWASData= gwas_data[TEST=="ADD", `:=`(
#   ALLELE0= stringr::str_to_upper(ALLELE0),
#   ALLELE1= stringr::str_to_upper(ALLELE1)
# )] %>%
#   .[, .(
#     SNP, ALLELE0, ALLELE1, A1FREQ, N, BETA, SE, P
#   )] %>%
#   .[, `:=`(
#     effectAllele= data.table::fifelse(A1FREQ > 0.5, ALLELE0, ALLELE1, ALLELE1),
#     otherAllele= data.table::fifelse(A1FREQ > 0.5, ALLELE1, ALLELE0, ALLELE0),
#     freqEffectAllele= data.table::fifelse(A1FREQ > 0.5, 1 - A1FREQ, A1FREQ, A1FREQ),
#     betaEffect= data.table::fifelse(A1FREQ > 0.5, -BETA, BETA, BETA)
#   )] %>%
#   .[freqEffectAllele >= maf_filter, ] %>%
#   .[, .(
#     SNP, effectAllele, otherAllele, freqEffectAllele, betaEffect, SE, P, N
#   )]

# gwas_data[, CHR:= as.character(CHR)] %>%
#   .[CHR %in% c("X", "x"), CHR := "23"] %>%
#   .[CHR %in% c("Y", "y"), CHR := "24"]


# duplicate_keys_in_used_info <- used_info[, .N, by = .(CHR, BP)][N > 1]
# if (nrow(duplicate_keys_in_used_info) > 0) {
#   print("Warning: Found duplicate keys in used_info!")
#   print(head(duplicate_keys_in_used_info))
# }
# duplicate_keys_in_gwas <- gwas_data[, .N, by = .(CHR, BP)][N > 1]
# if (nrow(duplicate_keys_in_gwas) > 0) {
#   print("Info: Found duplicate keys in gwas_data. These will be preserved in the join.")
#   print(head(duplicate_keys_in_gwas))
# }
# anno_gwas_data= used_info[gwas_data, on = .(CHR, BP)]
# # saveRDS(anno_gwas_data,
# #         file = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/anno_gwas_data.rds")

# # 5. prepared for gene-based testing
# # pryr::mem_change({
# #   anno_gwas_data= readRDS("/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/anno_gwas_data.rds")
# # })
# data.table::setDT(anno_gwas_data)
# anno_gwas_data[, .N, by = .(CHR, BP)][N > 1]

# anno_gwas_data %<>% .[!is.na(CHR),]
# duplicatedRows= anno_gwas_data[
#   , .N, by = .(SNP, ALLELE1, A1FREQ, BETA)
# ][N > 1]
# if(nrow(duplicatedRows) > 0) {
#   print("Warning: Found duplicate rows in anno_gwas_data!")
#   print(head(duplicatedRows))
# }
# # saveRDS(anno_gwas_data,
# #         file = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results/anno_gwas_data_v2.rds")

# anno_file= anno_gwas_data[, `:=`(
#   variant= paste0(CHR, ":", BP, ":", ALLELE0, ":", ALLELE1),
#   gene= GENE,
#   annotation= Consequence
# )][
#   (!is.na(gene) & !(gene %in% c("<NA>", "."))),
# ]
# duplicatedRowsofAnnoFile= anno_file[, .N, by= .(variant, gene)][N > 1]
# if(nrow(duplicatedRowsofAnnoFile) > 0){
#   print("Warning: Found duplicate rows in anno file prepared for regenie!")
#   print(head(duplicatedRowsofAnnoFile))
# }
# data.table::uniqueN(anno_file$annotation) #45

# consequence_score_map <- c(
#   # High impact
#   "transcript_ablation" = 1,
#   "splice_acceptor_variant" = 2,
#   "splice_donor_variant" = 3,
#   "stop_gained" = 4,
#   "frameshift_variant" = 5,
#   "stop_lost" = 6,
#   "start_lost" = 7,
#   "transcript_amplification" = 8,
#   "feature_elongation"= 9,
#   "feature_truncation"= 10,

#   # Moderate impact
#   "inframe_insertion" = 11,
#   "inframe_deletion" = 12,
#   "missense_variant" = 13,
#   "protein_altering_variant" = 14,

#   # Low impact
#   "splice_donor_5th_base_variant" = 15,
#   "splice_region_variant" = 16,
#   "splice_donor_region_variant" = 17,
#   "splice_polypyrimidine_tract_variant" = 18,
#   "incomplete_terminal_codon_variant" = 19,
#   "start_retained_variant" = 20,
#   "stop_retained_variant" = 21,
#   "synonymous_variant" = 22,

#   # Modifier impact
#   "coding_sequence_variant" = 23,
#   "mature_miRNA_variant" = 24,
#   "5_prime_UTR_variant" = 25,
#   "3_prime_UTR_variant" = 26,
#   "non_coding_transcript_exon_variant" = 27,
#   "intron_variant" = 28,
#   "NMD_transcript_variant" = 29,
#   "non_coding_transcript_variant" = 30,
#   "coding_transcript_variant"= 31,
#   "upstream_gene_variant" = 32,
#   "downstream_gene_variant" = 33,
#   "TFBS_ablation" = 34,
#   "TFBS_amplification" = 35,
#   "TF_binding_site_variant" = 36,
#   "regulatory_region_ablation" = 37,
#   "regulatory_region_amplification" = 38,
#   "regulatory_region_variant" = 39,
#   "intergenic_variant" = 40,
#   "sequence_variant" = 41,
#   "other"= 42
# )
# score_to_consequence_map= setNames(names(consequence_score_map), consequence_score_map)
# bucket_map <- list(
#   LoF          = c("transcript_ablation","splice_acceptor_variant",
#                    "splice_donor_variant","stop_gained","frameshift_variant",
#                    "stop_lost","start_lost","transcript_amplification",
#                    "feature_elongation","feature_truncation"),
#   Splice_Region = c("splice_donor_5th_base_variant", "splice_donor_region_variant",
#                     "splice_polypyrimidine_tract_variant", "splice_region_variant"),
#   Missense     = c("missense_variant","protein_altering_variant",
#                    "inframe_insertion","inframe_deletion"),
#   Synonymous   = c("synonymous_variant","stop_retained_variant","start_retained_variant",
#                    "incomplete_terminal_codon_variant"),
#   Noncoding    = c("5_prime_UTR_variant","3_prime_UTR_variant",
#                    "non_coding_transcript_exon_variant","intron_variant",
#                    "NMD_transcript_variant","non_coding_transcript_variant",
#                    "coding_sequence_variant","coding_transcript_variant",
#                    "upstream_gene_variant","downstream_gene_variant",
#                    "mature_miRNA_variant","TFBS_ablation","TFBS_amplification",
#                    "TF_binding_site_variant","regulatory_region_ablation",
#                    "regulatory_region_amplification","regulatory_region_variant",
#                    "intergenic_variant","sequence_variant","other")
# )
# bucket_vec <- unlist(lapply(names(bucket_map), \(k) setNames(rep(k, length(bucket_map[[k]])),
#                                                              bucket_map[[k]])))
# length(bucket_vec)
# anno_file[, severity_score := {
#   scores <- consequence_score_map[unlist(strsplit(annotation, "&"))]
#   min(scores, na.rm = TRUE)
# }, by = .I][
#   is.infinite(severity_score), `:=`(
#     annotation= "other",
#     severity_score= 42
#   )
# ][
#   , severity_score:= as.character(severity_score)
# ][
#   , annotation_v2 := score_to_consequence_map[severity_score]
# ][
#   , mask := bucket_vec[annotation_v2]
# ]
# anno_file[is.infinite(severity_score),] %>% nrow() # 0

# anno_file[A1FREQ < 0.1 | A1FREQ > 0.9, ][
#   , .N, by= .(mask)
# ]

# # mask file
# mask_lines <- c(
#   "LoF\tLoF",
#   "LoF_Splice_Region\tLoF,Splice_Region",
#   "Damaging_All\tLoF,Splice_Region,Missense",
#   "Missense_All\tMissense",
#   "Splice_Region\tSplice_Region",
#   "Synonymous\tSynonymous",
#   "Noncoding\tNoncoding"
# )
# data.table::fwrite(
#   data.table::data.table(mask = mask_lines),
#   file = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/gene_based_testing/mask_file.txt",
#   sep = "\t",
#   quote = FALSE,
#   na = "NA",
#   col.names = FALSE,
#   row.names = FALSE
# )

# # anno file
# # anno_file[SNP=="rs116018620",]
# anno_file[, .N, by= .(gene)]
# anno_file[is.na(SNP), .N, by= .(SNP)]
# # anno_file[, .(variant, gene, mask)] %>%
# anno_file[, .(SNP, gene, mask)] %>%
#   data.table::fwrite(
#     file = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/gene_based_testing/anno_file.txt",
#     sep = "\t",
#     quote = FALSE,
#     na = "NA",
#     col.names = FALSE,
#     row.names = FALSE
#   )

# # set list file
# # anno_file[, .(CHR, BP, gene, variant)][
# anno_file[, .(CHR, BP, gene, SNP)][
#   , .(
#     CHR_v2= data.table::first(CHR),
#     BP_v2= data.table::first(BP),
#     # all_variants = paste(variant, collapse = ",")
#     all_variants = paste(SNP, collapse = ",")
#   ),
#   by = .(gene, CHR)
# ][
#   , .(gene, CHR_v2, BP_v2, all_variants)
# ] %>%
#   data.table::fwrite(
#     file = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/gene_based_testing/set_list.txt",
#     sep = "\t",
#     quote = FALSE,
#     na = "NA",
#     col.names = FALSE,
#     row.names = FALSE
#   )
