#!/bin/bash
#SBATCH --job-name=Viking-7B-Monolingual-Code
#SBATCH --output=/scratch/project_462000506/members/zihao/slurmlog/mixing_ablation_eval/flores200/Eng-X-3shot/%x_%j.out
#SBATCH --error=/scratch/project_462000506/members/zihao/slurmlog/mixing_ablation_eval/flores200/Eng-X-3shot/%x_%j.err
#SBATCH --partition=small-g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=1
#SBATCH --time=3-00:00:00
#SBATCH --account=project_462000647

start_time=$(date +%s)
echo "Job started at: $(date)"

# Load environment
module use /appl/local/csc/modulefiles/
module load pytorch/2.4

export TRITON_CACHE_DIR="/scratch/project_462000506/cache/triton_cache_base/triton_cache"

# List of other models to evaluate (commented out for reference)
MODEL_IDS=(
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-3000
    # /scratch/project_462000447/members/zihao/saves/altruistic/bilingual/Llama-3-1-8B/checkpoint-4000
    # /scratch/project_462000447/members/zihao/saves/selfish/bilingual/Llama-3-1-8B/checkpoint-3500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/monolingual/Llama-3-1-8B/checkpoint-3000
    # /scratch/project_462000447/members/zihao/saves/altruistic/monolingual/Llama-3-1-8B/checkpoint-5500
    # /scratch/project_462000447/members/zihao/saves/selfish/monolingual/Llama-3-1-8B/checkpoint-3000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual_code/Llama-3-1-8B/checkpoint-3500
    # /scratch/project_462000447/members/zihao/saves/altruistic/bilingual_code/Llama-3-1-8B/checkpoint-5000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/selfish/bilingual_code/Llama-3-1-8B/checkpoint-4500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/monolingual_code/Llama-3-1-8B/checkpoint-3500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/altruistic/monolingual_code/Llama-3-1-8B/checkpoint-6000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/selfish/monolingual_code/Llama-3-1-8B/checkpoint-3500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-2-7B/checkpoint-3500
    # /scratch/project_462000447/members/zihao/saves/altruistic/bilingual/Llama-2-7B/checkpoint-5500
    # /scratch/project_462000447/members/zihao/saves/selfish/bilingual/Llama-2-7B/checkpoint-4000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/monolingual/Llama-2-7B/checkpoint-5000
    # /scratch/project_462000447/members/zihao/saves/altruistic/monolingual/Llama-2-7B/checkpoint-7500
    # /scratch/project_462000447/members/zihao/saves/selfish/monolingual/Llama-2-7B/checkpoint-3500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual_code/Llama-2-7B/checkpoint-4000
    # /scratch/project_462000447/members/zihao/saves/altruistic/bilingual_code/Llama-2-7B/checkpoint-6500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/selfish/bilingual_code/Llama-2-7B/checkpoint-5000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/monolingual_code/Llama-2-7B/checkpoint-5500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/altruistic/monolingual_code/Llama-2-7B/checkpoint-8000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/selfish/monolingual_code/Llama-2-7B/checkpoint-4000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Viking-7B/checkpoint-3000
    # /scratch/project_462000447/members/zihao/saves/altruistic/bilingual/Viking-7B/checkpoint-5000
    # /scratch/project_462000447/members/zihao/saves/selfish/bilingual/Viking-7B/checkpoint-4000
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/monolingual/Viking-7B/checkpoint-4500
    # /scratch/project_462000447/members/zihao/saves/altruistic/monolingual/Viking-7B/checkpoint-6500
    # /scratch/project_462000447/members/zihao/saves/selfish/monolingual/Viking-7B/checkpoint-3500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual_code/Viking-7B/checkpoint-3500
    # /scratch/project_462000447/members/zihao/saves/altruistic/bilingual_code/Viking-7B/checkpoint-5500
    # /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/selfish/bilingual_code/Viking-7B/checkpoint-4500
    /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/monolingual_code/Viking-7B/checkpoint-5000
    /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/altruistic/monolingual_code/Viking-7B/checkpoint-7000
    /scratch/project_462000506/members/zihao/LLaMA-Factory/saves/selfish/monolingual_code/Viking-7B/checkpoint-4000
)

RESULTS_DIRS=(
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Code-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Code-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Bilingual-Code-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Code-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Code-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-3.1-8B-Monolingual-Code-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Code-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Code-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Bilingual-Code-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Code-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Code-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Llama-2-7B-Monolingual-Code-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Selfish"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Code-Stagnant"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Code-Altruistic"
    # "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Bilingual-Code-Selfish"
    "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Code-Stagnant"
    "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Code-Altruistic"
    "/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/Eng-X-3shot/Viking-7B-Monolingual-Code-Selfish"
)

CONFIG_FILES=(
    "./stagnant_langs.txt"
    "./altruistic_langs.txt"
    "./selfish_langs.txt"
)


TGT_LANG="all" # either "eng_Latn" for 'X-eng' translation, or "all" for 'eng-X' translation
N_shots=3

for i in "${!MODEL_IDS[@]}"; do
    MODEL_ID="${MODEL_IDS[$i]}"
    RESULTS_DIR="${RESULTS_DIRS[$i]}"
    CONFIG_FILE="${CONFIG_FILES[$i]}"

    echo "Evaluating model: $MODEL_ID with config: $CONFIG_FILE"

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

    python ./eval_flores200.py \
        --langs "${CONFIGS[@]}" \
        --tgt_lang "$TGT_LANG" \
        --dataset_base_path "/scratch/project_462000506/members/zihao/dataset/FLORES-200" \
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
