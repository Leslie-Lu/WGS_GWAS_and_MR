#!/bin/bash -l
#SBATCH --job-name=gsMap
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40    
#SBATCH --time=88-00:00:00
#SBATCH --mem=102G
#SBATCH --partition=gpu
#SBATCH --output=/dev/null

EXEC="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/p116_gsMap.slurm"
SCRIPT_NAME=$(basename $EXEC .slurm)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="/share/home/lsy_luzhen/WGS_GWAS_and_MR/slurm/${SCRIPT_NAME}_${TIMESTAMP}.out"
exec > $OUTPUT_FILE 2>&1

echo 'start at:'
date
source /share/home/lsy_luzhen/software/miniconda3/bin/activate gsMap
echo "===Mouse Embryo (Quick Mode)==="
gsmap quick_mode \
    --workdir '/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/gsMap/quick_mode/Mouse_Embryo' \
    --homolog_file '/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/gsMap/gsMap_resource/homologs/mouse_human_homologs.txt' \
    --sample_name 'E16.5_E1S1.MOSTA' \
    --gsMap_resource_dir '/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/gsMap/gsMap_resource' \
    --hdf5_path '/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/gsMap/gsMap_example_data/ST/E16.5_E1S1.MOSTA.h5ad' \
    --annotation 'annotation' \
    --data_layer 'count' \
    --sumstats_file '/share/home/lsy_luzhen/WGS_GWAS_and_MR/tmp_ssh_data/gsMap/gsmap_euro_cin3plus.sumstats.gz' \
    --trait_name 'CIN3+'
conda deactivate
echo 'end at:'
date

