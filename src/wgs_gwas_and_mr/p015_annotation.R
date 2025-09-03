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

# # --- 3. format used_info ---
# outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2"
# used_info= readRDS(
#   file = file.path(outputDir, "allAnnotatedChrs_info_used.rds")
# )
# data.table::setDT(used_info)
# message("Unique chromosomes in used_info: ", paste(used_info$CHR %>% unique() %>% sort(), collapse = ", "))
# used_info[,
#   CHR := data.table::fifelse(CHR %in% c("X", "x"), "23", CHR, "Error")
# ][,
#   CHR := data.table::fifelse(CHR %in% c("Y", "y"), "24", CHR, "Error")
# ]
# message("Number of variants by chromosomes: ")
# print(used_info[, .N, by = CHR])
# message("Dimensions of used_info: ", paste(dim(used_info), collapse = ", "))
# # --- 3b. debug ---
# # tryCatch({
# #   message("Number of unique SNPs in used_info: ", data.table::uniqueN(used_info, by = "SNP"))
# # }, error = function(e) {
# #   message("Error in counting unique SNPs in used_info: ", e$message)
# # }, warning = function(w) {
# #   message("Warning in counting unique SNPs in used_info: ", w$message)
# # })
# # variantsMap2Genes= used_info[, .(SNP)]
# # tryCatch({
# #   message("Number of unique SNPs in variantsMap2Genes: ", data.table::uniqueN(variantsMap2Genes, by = "SNP"))
# # }, error = function(e) {
# #   message("Error in counting unique SNPs in variantsMap2Genes: ", e$message)
# # }, warning = function(w) {
# #   message("Warning in counting unique SNPs in variantsMap2Genes: ", w$message)
# # })
# used_info[, .(SNP, OLD_RS, GENE)] %>%
#   data.table::fwrite(
#     file = file.path(outputDir, "variantsMap2Genes.txt"),
#     sep = "\t",
#     quote = FALSE,
#     col.names = FALSE
#   )
# saveRDS(used_info,
#         file = file.path(outputDir, "allAnnotatedChrs_info_used_v2.rds"))

# --- 4. Annotate the regenie gwas results ---
regenie_results= data.table::fread("/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all.regenie")
regenie_results[, P := 10^(-LOG10P)] %>%
    data.table::setnames(
        c("CHROM", "GENPOS", "ID"),
        c("CHR", "BP", "SNP")
    )
print(head(regenie_results))
regenie_results %>%
    data.table::fwrite("/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v2.regenie")

outputDir = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2"
outputDir2 = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2"
inputFile2= "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/step2/WGS_regenie_step2_euro_cin3plus_all_v2.regenie"
used_info= data.table::fread(file.path(outputDir, "variantsMap2Genes_v2.txt"),
                             header = FALSE,
                             col.names = c("SNP", "ANNO_RSID", "ANNO_GENE"))
used_info %>% head()
gwas_data= data.table::fread(inputFile2)

# maf_filter= 0
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

gwas_data[, CHR:= as.character(CHR)] %>%
  .[CHR %in% c("X", "x"), CHR := "23"] %>%
  .[CHR %in% c("Y", "y"), CHR := "24"]
message("Dimensions of gwas_data: ", paste(dim(gwas_data), collapse = ", "))
message("Number of unique SNPs in gwas_data: ", data.table::uniqueN(gwas_data, by = "SNP"))
message("Number of unique CHRs in gwas_data: ", data.table::uniqueN(gwas_data, by = "CHR"))

gwas_snps <- unique(gwas_data$SNP)
n_gwas_snps= length(gwas_snps)
message("Unique SNPs in GWAS: ", n_gwas_snps)
data.table::fwrite(
  gwas_data,
  file = file.path(outputDir2, "WGS_regenie_step2_euro_cin3plus_all_v3.regenie"),
  sep = ",",
  quote = FALSE
)

# # ###############
# # --- 4a. not working ---
# # ###############
# # Sys.setenv(OMP_THREAD_LIMIT = "1")
# # data.table::setDTthreads(1)
# # data.table::setkey(used_info, SNP)
# # used_info_filtered <- used_info[J(batch_snps), nomatch = 0]
# # rm(used_info)

# # # batch_size= 10000
# # # result_list <- list()
# # # for (i in seq(1, n_gwas_snps, by = batch_size)) {
# # #   batch_snps <- gwas_snps[i:min(i + batch_size - 1, n_gwas_snps)]
# # #   # used_info_batch <- used_info[J(batch_snps), nomatch = 0]
# # #   used_info_batch <- used_info[SNP %in% batch_snps]
# # #   result_list[[length(result_list) + 1]] <- used_info_batch
# # #   message("Processed batch ", length(result_list), ": ", length(batch_snps), " SNPs")
# # #   gc()
# # # }
# # # rm(used_info)
# # # used_info_filtered <- data.table::rbindlist(result_list)

# # message("Dimensions of used_info_filtered: ", paste(dim(used_info_filtered), collapse = ", "))

# # anno_gwas_data= used_info_filtered[gwas_data, on = .(SNP), allow.cartesian = TRUE]
# # message("Dimensions of anno_gwas_data: ", paste(dim(anno_gwas_data), collapse = ", "))
# # ###############
# # --- 4b. try out awk ---
# # ###############
# # run: WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p015_annotation.sh
# # data.table::fwrite(
# #   anno_gwas_data,
# #   file = file.path(outputDir2, "WGS_regenie_step2_euro_cin3plus_all_v3_anno.regenie"),
# #   sep = ",",
# #   quote = FALSE
# # )



# --- 5. Preparation for gene-based testing ---
# outputDir= "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/gene_based_testing"
# vep_used_info= readRDS(
#   file = "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results_v2/allAnnotatedChrs_info_used_v2.rds"
# )
# data.table::setDT(vep_used_info)
# vep_used_info %>% head(6)
# vep_used_info %>% dim()
# data.table::fwrite(
#   vep_used_info,
#   file = file.path(outputDir, "allAnnotatedChrs_info_used_v2.txt"),
#   sep = "\t",
#   quote = FALSE,
#   col.names = FALSE,
#   row.names = FALSE
# )

# outputDir= "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/gene_based"
# inputFile3= "/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/VEP/gene_based_testing/allAnnotatedChrs_info_used_v2.txt"
# vep_used_info_gwas= data.table::fread(
#   inputFile3,
#   col.names = c("CHR", "BP", "SNP", "OLD_RS", "GENE", "IMPACT", "Consequence")
# )
# vep_used_info_gwas %>% head(6)
# vep_used_info_gwas %>% dim()

# anno_file= vep_used_info_gwas[, .(CHR, BP, SNP, GENE, Consequence)]
# message("Number of variants by Consequence: ")
# print(anno_file[, .N, by = Consequence]) #32
# consequence_list <- unique(unlist(strsplit(anno_file$Consequence, "&")))
# message("Number of unique Consequence terms: ", length(consequence_list))
# message("Unique Consequence terms: \n", paste(consequence_list, collapse = "\n"))

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
# print(consequence_score_map)
# message(
#   "Number of consequence terms in the map: ",
#   sum(consequence_list %in% names(consequence_score_map))
# )

# score_to_consequence_map= setNames(names(consequence_score_map), as.character(unname(consequence_score_map)))
# print(score_to_consequence_map)
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
# message("Number of elements in bucket_map: ", length(unlist(bucket_map)))
# names(bucket_map)

# bucket_vec <- unlist(lapply(names(bucket_map), \(k) setNames(rep(k, length(bucket_map[[k]])),
#                                                              bucket_map[[k]])))
# message("Number of elements in bucket_vec: ", length(bucket_vec))
# print(bucket_vec)
# anno_file[, severity_score := {
#   scores <- consequence_score_map[unlist(strsplit(Consequence, "&"))]
#   min(scores, na.rm = TRUE)
# }, by = .I][
#   is.infinite(severity_score), `:=`(
#     Consequence= "other",
#     severity_score= 42
#   )
# ][
#   , severity_score:= as.character(severity_score)
# ][
#   , Consequence_v2 := score_to_consequence_map[severity_score]
# ][
#   , mask := bucket_vec[Consequence_v2]
# ]
# anno_file %>% head(6)
# message("Number of variants by severity_score: ")
# print(anno_file[, .N, by = severity_score]) #32
# message("Number of variants by Consequence_v2: ")
# print(anno_file[, .N, by = Consequence_v2]) #32
# message("Number of variants by mask: ")
# print(anno_file[, .N, by = mask]) #5

# # creating mask file
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
#   file = file.path(outputDir, "mask_file.txt"),
#   sep = "\t",
#   quote = FALSE,
#   na = "NA",
#   col.names = FALSE,
#   row.names = FALSE
# )
# # creating anno file
# anno_file[, .(SNP, GENE, mask)] %>%
#   # unique() %>%
#   data.table::fwrite(
#     file = file.path(outputDir, "anno_file.txt"),
#     sep = "\t",
#     quote = FALSE,
#     na = "NA",
#     col.names = FALSE,
#     row.names = FALSE
#   )

# # creating set list file
# anno_file[, .(CHR, BP, SNP, GENE)][
#   , BP := as.integer(BP)
# ][order(CHR, BP), .(
#   CHR_v2= unique(CHR),
#   BP_v2= min(BP, na.rm = TRUE),
#   all_variants = paste(unique(SNP), collapse = ",")
# ), by = .(GENE, CHR)
# ][
#   , .(GENE, CHR_v2, BP_v2, all_variants)
# ] %>%
#   # unique() %>%
#   data.table::fwrite(
#     file = file.path(outputDir, "set_list.txt"),
#     sep = "\t",
#     quote = FALSE,
#     na = "NA",
#     col.names = FALSE,
#     row.names = FALSE
#   )
