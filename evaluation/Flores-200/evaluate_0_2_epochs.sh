#!/bin/bash
#SBATCH --job-name=calculate-Llama-3.1-8B-Monolingual-Stagnant
#SBATCH --output=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/X-Eng-0-2-epoch-DE/%x_%j.out
#SBATCH --error=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/X-Eng-0-2-epoch-DE/%x_%j.err
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
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-1000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-1500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-2000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-2500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-3000
)

TYPES=(
    Llama-3.1-8B-Monolingual-Stagnant
    Llama-3.1-8B-Monolingual-Stagnant
    Llama-3.1-8B-Monolingual-Stagnant
    Llama-3.1-8B-Monolingual-Stagnant
    Llama-3.1-8B-Monolingual-Stagnant
    Llama-3.1-8B-Monolingual-Stagnant
)

for i in "${!TRANSLATIONS_DIRS[@]}"; do
    TRANSLATIONS_DIR="${TRANSLATIONS_DIRS[$i]}"
    MODEL_ID=$(echo "Evaluating model: $TRANSLATIONS_DIR" | awk -F'/' '{print $(NF)}')
    TYPE="${TYPES[$i]}"

    python ./evaluate.py \
        --translations_dir "$TRANSLATIONS_DIR" \
        --output_dir "Results/X-Eng-0-2-epochs/${TYPE}"\
        --model_id "$MODEL_ID" \
        --task_name "${TYPE}-Flores-200-X-En"
done

duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"