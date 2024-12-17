#!/bin/bash
#SBATCH --job-name=Llama-3.1-8B-Bilingual-N
#SBATCH --output=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/Eng-X-N/%x_%j.out
#SBATCH --error=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/flores200/Eng-X-N/%x_%j.err
#SBATCH --partition=gpusmall
#SBATCH --nodes=1
#SBATCH --time=8:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8000
#SBATCH --gres=gpu:a100:1
#SBATCH --account=project_2001403

start_time=$(date +%s)
echo "Job started at: $(date)"

# Load environment
source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_2005099/members/zihao/env/vllm_env

# List of other models to evaluate (commented out for reference)
MODEL_IDS=(
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Bilingual-Altruistic/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Bilingual-Code-Altruistic/checkpoint-6500
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Bilingual-Code-Selfish/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Bilingual-Code-Stagnant/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Bilingual-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Bilingual-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Monolingual-Altruistic/checkpoint-7500
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Monolingual-Code-Altruistic/checkpoint-8000
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Monolingual-Code-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Monolingual-Code-Stagnant/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Monolingual-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Llama-2-7B-Monolingual-Stagnant/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Bilingual-Altruistic/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Bilingual-Code-Altruistic/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Bilingual-Code-Selfish/checkpoint-4500
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Bilingual-Code-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Bilingual-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Bilingual-Stagnant/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Monolingual-Altruistic/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Monolingual-Code-Altruistic/checkpoint-6000
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Monolingual-Code-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Monolingual-Code-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Monolingual-Selfish/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/models/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Bilingual-Altruistic/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Bilingual-Code-Altruistic/checkpoint-5500
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Bilingual-Code-Selfish/checkpoint-4500
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Bilingual-Code-Stagnant/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Bilingual-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Bilingual-Stagnant/checkpoint-3000
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Monolingual-Altruistic/checkpoint-6500
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Monolingual-Code-Altruistic/checkpoint-7000
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Monolingual-Code-Selfish/checkpoint-4000
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Monolingual-Code-Stagnant/checkpoint-5000
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Monolingual-Selfish/checkpoint-3500
    /scratch/project_2005099/members/zihao/mala/models/Viking-7B-Monolingual-Stagnant/checkpoint-4500
)

BASE_RESULTS_DIR="/scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-128-N"

CONFIG_FILES=(
    "./altruistic_langs.txt"
    "./altruistic_langs.txt"
    "./selfish_langs.txt"
    "./stagnant_langs.txt"
    "./selfish_langs.txt"
    "./stagnant_langs.txt"
)


TGT_LANG="all" # either "eng_Latn" for 'X-eng' translation, or "all" for 'eng-X' translation
N_shots=3

for i in "${!MODEL_IDS[@]}"; do
    MODEL_ID="${MODEL_IDS[$i]}"
    MODEL_PART=$(echo "$MODEL_ID" | awk -F'/' '{print $(NF-1)}')
    RESULTS_DIR="$BASE_RESULTS_DIR/$MODEL_PART"
    CONFIG_FILE="${CONFIG_FILES[$i]}"

    echo "Evaluating model: $MODEL_PART with config: $CONFIG_FILE"

    # Check if config file exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Config file not found: $CONFIG_FILE"
        continue
    fi

    # Read languages from config file
    CONFIGS=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ ! -z "$line" ]]; then
            CONFIGS+=("$line")
        fi
    done <"$CONFIG_FILE"

    python ./eval_flores200_N.py \
        --langs "${CONFIGS[@]}" \
        --tgt_lang "$TGT_LANG" \
        --dataset_base_path "/scratch/project_2005099/members/zihao/dataset/flores200_dataset" \
        --results_dir "$RESULTS_DIR" \
        --tgt_lang "$TGT_LANG" \
        --model_id "$MODEL_ID" \
        --nshots "$N_shots" \
        --tensor_parallel_size 1 \
        --max_num_seqs 16 \
        --dtype 'auto' \
        --seed 42
done

end_time=$(date +%s)
echo "Job ended at: $(date)"

duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"
