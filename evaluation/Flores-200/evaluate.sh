#!/bin/bash
#SBATCH --job-name=flores200_metrics
#SBATCH --output=logs/flores200_metrics_%j.out
#SBATCH --error=logs/flores200_metrics_%j.err
#SBATCH --partition=test
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=16G
#SBATCH --account=your_project_account

# Record start time
start_time=$(date +%s)
echo "Job started at: $(date)"

# Load conda environment
# source /path/to/conda/etc/profile.d/conda.sh
# conda activate your_evaluation_environment

TRANSLATIONS_DIRS=(
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Altruistic/checkpoint-5500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Code-Altruistic/checkpoint-6500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Code-Selfish/checkpoint-5000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Code-Stagnant/checkpoint-4000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Selfish/checkpoint-4000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Stagnant/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Altruistic/checkpoint-7500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Code-Altruistic/checkpoint-8000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Code-Selfish/checkpoint-4000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Code-Stagnant/checkpoint-5500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Selfish/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Stagnant/checkpoint-5000
    /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Altruistic/checkpoint-4000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Code-Altruistic/checkpoint-5000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Code-Selfish/checkpoint-4500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Code-Stagnant/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Selfish/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Stagnant/checkpoint-3000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Altruistic/checkpoint-5500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Code-Altruistic/checkpoint-6000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Code-Selfish/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Code-Stagnant/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Selfish/checkpoint-3000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-3000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Altruistic/checkpoint-5000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Code-Altruistic/checkpoint-5500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Code-Selfish/checkpoint-4500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Code-Stagnant/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Selfish/checkpoint-4000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Stagnant/checkpoint-3000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Altruistic/checkpoint-6500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Code-Altruistic/checkpoint-7000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Code-Selfish/checkpoint-4000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Code-Stagnant/checkpoint-5000
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Selfish/checkpoint-3500
    # /scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Stagnant/checkpoint-4500
)

TYPES=(
    Altruistic
    # Altruistic
    # Selfish
    # Stagnant
    # Selfish
    # Stagnant
    # Altruistic
    # Altruistic
    # Selfish
    # Stagnant
    # Selfish
    # Stagnant
    # Altruistic
    # Altruistic
    # Selfish
    # Stagnant
    # Selfish
    # Stagnant
    # Altruistic
    # Altruistic
    # Selfish
    # Stagnant
    # Selfish
    # Stagnant
    # Altruistic
    # Altruistic
    # Selfish
    # Stagnant
    # Selfish
    # Stagnant
    # Altruistic
    # Altruistic
    # Selfish
    # Stagnant
    # Selfish
    # Stagnant
)

for i in "${!TRANSLATIONS_DIRS[@]}"; do
    TRANSLATIONS_DIR="${TRANSLATIONS_DIRS[$i]}"
    MODEL_ID=$(echo "Evaluating model: $TRANSLATIONS_DIR" | awk -F'/' '{print $(NF-1)}')
    TYPE="${TYPES[$i]}"

    python ./evaluate.py \
        --translations_dir "$TRANSLATIONS_DIR" \
        --output_dir "Results/Eng-X-3shot"\
        --model_id "$MODEL_ID" \
        --task_name "${TYPE}-Flores-200-Eng-X-3shot"
done

duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"