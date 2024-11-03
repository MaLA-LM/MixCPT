#!/bin/bash
#SBATCH --job-name=Llama-3.1-8B-Bilingual-Stagnant
#SBATCH --output=/scratch/project_462000506/members/zihao/slurmlog/mixing_ablation_eval/flores200/%x_%j.out
#SBATCH --error=/scratch/project_462000506/members/zihao/slurmlog/mixing_ablation_eval/flores200/%x_%j.err
#SBATCH --partition=small-g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=2
#SBATCH --time=1-00:00:00
#SBATCH --account=project_462000647

start_time=$(date +%s)
echo "Job started at: $(date)"

# Load environment
module use /appl/local/csc/modulefiles/
module load pytorch/2.4

# List of other models to evaluate (commented out for reference)
MODEL_IDS=(
    # "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-1000"
    "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-1500"
    # "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-2000"
    # "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-2500"
    # "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-3000"
    # "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-3500"
    # "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-4000"
)

RESULTS_DIR="/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Flores-200/Translations/X-Eng-3shot/Llama-3.1-8B-Bilingual-Stagnant"

TGT_LANG="eng_Latn" # either "eng_Latn" for 'X-eng' translation, or "all" for 'eng-X' translation
N_shots=3

CONFIG_FILE="./stagnant_langs.txt"
CONFIGS=()

if [[ -f "$CONFIG_FILE" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ ! -z "$line" ]]; then
            CONFIGS+=("$line")
        fi
    done <"$CONFIG_FILE"
else
    echo "Config file not found!"
    exit 1
fi

if [ ${#CONFIGS[@]} -eq 0 ]; then
    echo "No configs found in $CONFIG_FILE"
    exit 1
fi

for MODEL_ID in "${MODEL_IDS[@]}"; do
    echo "Evaluate model: $MODEL_ID"
    python ./eval_flores200.py \
        --langs "${CONFIGS[@]}" \
        --tgt_lang "$TGT_LANG" \
        --dataset_base_path "/scratch/project_462000506/members/zihao/dataset/FLORES-200" \
        --results_dir "$RESULTS_DIR" \
        --tgt_lang "$TGT_LANG" \
        --model_id "$MODEL_ID" \
        --nshots "$N_shots" \
        --tensor_parallel_size 2 \
        --max_num_seqs 32 \
        --dtype 'auto' \
        --seed 42
done

end_time=$(date +%s)
echo "Job ended at: $(date)"

duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"
