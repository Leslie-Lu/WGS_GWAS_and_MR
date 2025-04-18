###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p007_QC_european.sh
# DESCRIPTION       : QC for European ancestry individuals on DNAnexus platform and/or local
# DATE CREATED      : 2025-04-18
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-04-18
# REASON            : Initial version
################################################################################################

# 1. keep only European ancestry individuals
dx run app-swiss-army-knife/4.13.1 \
    --name "count sample size in WGS" \
    -iin=project-Gzq6k90JVYVBKYKVg2b4G82J:/ZL_20250409/F001EligibleWomen/file-J00kyy0Jf8J467xbqfbGpKXQ \
    -imount_inputs=true \
    --instance-type mem1_ssd1_v2_x2 \
    -icmd="wc -l eligible_cases_and_controls_plink2.psam | awk '{print \"总样本量:\", \$1-1}'" \
    --watch -y --brief
