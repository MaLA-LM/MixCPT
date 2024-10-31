#!/bin/bash
#SBATCH --job-name=clean_yo
#SBATCH --output=/scratch/project_462000506/members/zihao/slurmlog/madlad/%x_%j.out
#SBATCH --error=/scratch/project_462000506/members/zihao/slurmlog/madlad/%x_%j.err
#SBATCH --partition=small
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=2
#SBATCH --time=24:00:00
#SBATCH --mem=256G
#SBATCH --account=project_462000506


source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_462000506/members/zihao/mala_data_env

BASE_DIR="/scratch/project_462000506/members/zihao/MADLAD-400"
MODEL_PATH='/scratch/project_462000506/cache/huggingface/hub/models--cis-lmu--glotlid/snapshots/083bc2c08b05dd302e5069eb89c956d4734cf3a3/model.bin'
# LANGUAGES="ky ny gu ig km pa zu sn wo"
# LANGUAGES="oc be mi ceb mr th"
# LANGUAGES="de_10"
# LANGUAGES="zh"
# LANGUAGES="en_33"
# LANGUAGES="pt_6"
# LANGUAGES="ja"
# LANGUAGES="th"
LANGUAGES="yo"

python /scratch/project_462000506/members/zihao/mixing-ablation/bilingual_instances_detect/detect.py \
    --base_dir $BASE_DIR \
    --languages $LANGUAGES \
    --model_path $MODEL_PATH
