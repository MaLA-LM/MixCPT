#!/bin/bash
#SBATCH --job-name=calculate-Viking-7B-Monolingual-Selfish
#SBATCH --output=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/Eng-X-0-2-epoch-DE/%x_%j.out
#SBATCH --error=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/Eng-X-0-2-epoch-DE/%x_%j.err
#SBATCH --partition=medium
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=16G
#SBATCH --account=project_2001403

# Record start time
start_time=$(date +%s)
echo "Job started at: $(date)"

# Load conda environment
source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_2005099/members/zihao/env/vllm_env

TRANSLATIONS_DIRS=(
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128/Viking-7B-Monolingual-Selfish/checkpoint-500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128/Viking-7B-Monolingual-Selfish/checkpoint-1000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128/Viking-7B-Monolingual-Selfish/checkpoint-1500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128/Viking-7B-Monolingual-Selfish/checkpoint-2000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128/Viking-7B-Monolingual-Selfish/checkpoint-2500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128/Viking-7B-Monolingual-Selfish/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128/Viking-7B-Monolingual-Selfish/checkpoint-3500

)

TYPES=(
    Viking-7B-Monolingual-Selfish
    Viking-7B-Monolingual-Selfish
    Viking-7B-Monolingual-Selfish
    Viking-7B-Monolingual-Selfish
    Viking-7B-Monolingual-Selfish
    Viking-7B-Monolingual-Selfish
    Viking-7B-Monolingual-Selfish
)

for i in "${!TRANSLATIONS_DIRS[@]}"; do
    TRANSLATIONS_DIR="${TRANSLATIONS_DIRS[$i]}"
    MODEL_ID=$(echo "Evaluating model: $TRANSLATIONS_DIR" | awk -F'/' '{print $(NF)}')
    TYPE="${TYPES[$i]}"

    python ./evaluate.py \
        --translations_dir "$TRANSLATIONS_DIR" \
        --output_dir "Results/Eng-X-0-2-epochs/${TYPE}"\
        --model_id "$MODEL_ID" \
        --task_name "${TYPE}-Flores-200-De-En"
done

duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"