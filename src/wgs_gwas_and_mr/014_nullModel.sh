export PATH=/share/home/lsy_guoxinxin/software:/share/home/lsy_guoxinxin/singularity-ce/bin:/share/home/lsy_guoxinxin/go/src/github.com/sylabs/go/bin:/share/home/lsy_guoxinxin/go/src/github.com/sylabs/go:/share/home/lsy_guoxinxin/miniconda3/envs/RSAIGE/bin:/share/home/lsy_guoxinxin/miniconda3/condabin:/share/home/lsy_guoxinxin/.local/bin:/share/home/lsy_guoxinxin/bin:/opt/xcat/bin:/opt/xcat/sbin:/opt/xcat/share/xcat/tools:/usr/share/Modules/bin:/opt/lenovo/onecli:/usr/lpp/mmfs/bin:/share/base/bin:/opt/confluent/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/openssh/9.0p1/bin:/usr/local/sbin:/share/home/lsy_guoxinxin/singularity-ce/bin

threads=$(nproc)

time Rscript /share/home/lsy_guoxinxin/software/SAIGE/extdata/step1_fitNULLGLMM.R \
      --plinkFile=/share/home/lsy_luzhen/full_model_result/14_ukb/GWAS/output/QC/clean_data_relabel \
      --sparseGRMFile=/share/home/lsy_luzhen/full_model_result/14_ukb/GWAS/output/saige/sparseGRM/sparseGRM_euro_relatednessCutoff_0.125_200000_randomMarkersUsed.sparseGRM.mtx \
      --sparseGRMSampleIDFile=/share/home/lsy_luzhen/full_model_result/14_ukb/GWAS/output/saige/sparseGRM/sparseGRM_euro_relatednessCutoff_0.125_200000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
      --traitType=binary \
      --nThreads=${threads} \
      --phenoFile=/share/home/lsy_luzhen/full_model_result/14_ukb/GWAS/output/saige/sparseGRM/pheno.txt \
      --phenoCol=plink_endpoint \
      --qCovarColList=ethnic_background_cat,Genotype_batch_cat,alcohol_consumption_cat,smoking_status_cat \
      --useSparseGRMtoFitNULL=TRUE \
      --covarColList=PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,age_bl_num,BMI_bl_num,Townsend_score_bl_num \
      --sampleIDColinphenoFile=IID \
      --outputPrefix=/share/home/lsy_luzhen/full_model_result/14_ukb/GWAS/output/saige/sparseGRM/step1_all_nullGLMM \
      --isCateVarianceRatio=TRUE \
      --IsOverwriteVarianceRatioFile=TRUE \
      --minMAFforGRM=0.001
wait
