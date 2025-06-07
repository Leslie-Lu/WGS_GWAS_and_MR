###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p015_annotation.r
# DESCRIPTION       : To define functional annotations for variants.
# DATE CREATED      : 2025-06-03
# INSPIRED BY       : /share/home/lsy_liuyanhong/20221125_metaGWAS/20230902_ICP/bin/add_info_to_meta_results.R
#                     /share/home/lsy_guyuqin/meta_analysis/phemap_220108/bin/add_annotation_info_to_meta_results.R
# INPUT             : 
# OUTPUT            : 
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-06-03
# REASON            : Initial version
################################################################################################
rm(list = ls())
gc()

# lulab.utils::test_mirror("China")
# options(repos = c(CRAN = 'https://mirrors.ustc.edu.cn/CRAN/'))
# install.packages("data.table")
library(lulab.utils)
library(magrittr)
library(dplyr)
library(data.table)
library(purrr)

# vep_results= fread(
#   '/mnt/lsy/OS5300/data/public_data/vep_10K_reference_panel/Allchr.CGP.beagle52.filter.vep_annotation_info.gz'
# )

save(list = ls(), file = "WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results.RData")
load("WGS_GWAS_and_MR/tmp_ssh_data/VEP/vep_results.RData")


vep_results %>% dim()
vep_results %>% names()
vep_results %>% head()

extract_vep= vep_results[, .(CHR, BP, GENE, IMPACT, Consequence)]
extract_vep[, CHR:= fifelse(CHR == "X", "23", CHR)]

# waiting for merging with gwas summary statistics
meta_gwas= fread(
  "WGS_GWAS_and_MR/tmp_ssh_data/GWAS_european/meta_gwas_summary_cin3plus.meta.format.gz",
  sep = ""
)




# meta_results_INFO$BP<-as.character(meta_results_INFO$BP)
# meta_results_INFO$CHR<-as.character(meta_results_INFO$CHR)
# vep_results1$BP<-as.character(vep_results1$BP)
# meta_results_INFO<-merge(meta_results_INFO,vep_results1,by=c('CHR','BP'),all.x=T)
# meta_results_INFO[which(is.na(meta_results_INFO),arr.ind = T)]<-'NA'
# meta_results_INFO<-subset(meta_results_INFO,CHR!='NA')
# print(nrow(meta_results_INFO))
# meta_results_INFO<-meta_results_INFO[!duplicated(meta_results_INFO[,c(1,2,4,5)]),]
# print(nrow(meta_results_INFO))
# fwrite(meta_results_INFO,paste(work_dir,'/',pheno,'.meta.format.gz',sep=''),sep = '\t')
