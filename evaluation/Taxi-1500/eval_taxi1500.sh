#!/bin/bash
#SBATCH --job-name=Llama-3.1-8B-Bilingual-Stagnant
#SBATCH --output=/scratch/project_462000506/members/zihao/slurmlog/mixing_ablation_eval/taxi1500/%x_%j.out
#SBATCH --error=/scratch/project_462000506/members/zihao/slurmlog/mixing_ablation_eval/taxi1500/%x_%j.err
#SBATCH --partition=small-g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=1
#SBATCH --time=12:00:00
#SBATCH --account=project_462000647

start_time=$(date +%s)
echo "Job started at: $(date)"

# Load conda environment
module use /appl/local/csc/modulefiles/
module load pytorch/2.4

# List of other models to evaluate (commented out for reference)
MODEL_IDS=(
    "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-1000"
    "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-2000"
    "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-3000"
    "/scratch/project_462000506/members/zihao/LLaMA-Factory/saves/stagnant/bilingual/Llama-3-1-8B/checkpoint-4000"
)

DATASET_PATH="/scratch/project_462000506/members/zihao/dataset/Taxi1500"
RESULTS_DIR="/scratch/project_462000506/members/zihao/MaLA-LM/mixing-ablation/evaluation/Taxi-1500/Results/Llama-3.1-8B-Bilingual-Stagnant"
DEVICE_INPUT="cuda:0"
NUM_EXAMPLES=3
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
    CUDA_VISIBLE_DEVICES=0,1 python ./eval_taxi1500.py \
        --configs "${CONFIGS[@]}" \
        --dataset_base_path "$DATASET_PATH" \
        --results_dir "$RESULTS_DIR" \
        --model_id "$MODEL_ID" \
        --device "$DEVICE_INPUT" \
        --num_examples "$NUM_EXAMPLES" \
        --seed 42
done

# Record the end time
end_time=$(date +%s)
echo "Job ended at: $(date)"

# Calculate and display the duration
duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"
