#!/bin/bash
#SBATCH --job-name=calculate
#SBATCH --output=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/X-Eng/%x_%j.out
#SBATCH --error=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/X-Eng/%x_%j.err
#SBATCH --partition=medium
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=16G
#SBATCH --account=project_2001403

# Record start time
start_time=$(date +%s)
echo "Job started at: $(date)"

# Load conda environment
source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_2005099/members/zihao/env/vllm_env

TRANSLATIONS_DIRS=(
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Bilingual-Altruistic/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Bilingual-Code-Altruistic/checkpoint-6500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Bilingual-Code-Selfish/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Bilingual-Code-Stagnant/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Bilingual-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Bilingual-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Monolingual-Altruistic/checkpoint-7500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Monolingual-Code-Altruistic/checkpoint-8000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Monolingual-Code-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Monolingual-Code-Stagnant/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Monolingual-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-2-7B-Monolingual-Stagnant/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Bilingual-Altruistic/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Bilingual-Code-Altruistic/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Bilingual-Code-Selfish/checkpoint-4500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Bilingual-Code-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Bilingual-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Bilingual-Stagnant/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Altruistic/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Code-Altruistic/checkpoint-6000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Code-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Code-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Selfish/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Bilingual-Altruistic/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Bilingual-Code-Altruistic/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Bilingual-Code-Selfish/checkpoint-4500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Bilingual-Code-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Bilingual-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Bilingual-Stagnant/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Monolingual-Altruistic/checkpoint-6500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Monolingual-Code-Altruistic/checkpoint-7000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Monolingual-Code-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Monolingual-Code-Stagnant/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Monolingual-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-128/Viking-7B-Monolingual-Stagnant/checkpoint-4500
)

TYPES=(
    Altruistic
    Altruistic
    Selfish
    Stagnant
    Selfish
    Stagnant
    Altruistic
    Altruistic
    Selfish
    Stagnant
    Selfish
    Stagnant
    Altruistic
    Altruistic
    Selfish
    Stagnant
    Selfish
    Stagnant
    Altruistic
    Altruistic
    Selfish
    Stagnant
    Selfish
    Stagnant
    Altruistic
    Altruistic
    Selfish
    Stagnant
    Selfish
    Stagnant
    Altruistic
    Altruistic
    Selfish
    Stagnant
    Selfish
    Stagnant
)

for i in "${!TRANSLATIONS_DIRS[@]}"; do
    TRANSLATIONS_DIR="${TRANSLATIONS_DIRS[$i]}"
    MODEL_ID=$(echo "Evaluating model: $TRANSLATIONS_DIR" | awk -F'/' '{print $(NF-1)}')
    TYPE="${TYPES[$i]}"

    python ./evaluate.py \
        --translations_dir "$TRANSLATIONS_DIR" \
        --output_dir "Results/X-Eng-128"\
        --model_id "$MODEL_ID" \
        --task_name "${TYPE}-Flores-200-X-Eng"
done

duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"