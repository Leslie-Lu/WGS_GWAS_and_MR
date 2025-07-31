#!/usr/bin/perl
###############################################################################################
# PROJECT NAME      : WGS_GWAS_and_MR/src/wgs_gwas_and_mr/p021_pca_tw_test.perl
# DESCRIPTION       : Tracy-Widom test for PCA results
# DATE CREATED      : 2025-07-31
# INSPIRED BY       : https://github.com/chrchang/eigensoft/blob/e7a66ede12a3e6567e491f14f2980119d84d6162/POPGEN/twexample.perl#L4
################################################################################################
# DATE MODIFIED     : 2025-07-31
# REASON            : Initial version
################################################################################################

$command = "/share/home/lsy_luzhen/software/miniconda3/envs/eigensoft/bin/twstats";
$command .= " -t /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european/smartpca_outcome_cc_cin3/euro_cc_cin3.eigenvec";
$command .= " -i /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european/smartpca_outcome_cc_cin3/eigen.eval";
$command .= " -o /share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/PCA_european/smartpca_outcome_cc_cin3/twstats.out";
print("$command\n");
system("$command");
