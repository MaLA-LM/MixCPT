#!/bin/bash
#SBATCH --job-name=Llama-2-7B-Based-3shots
#SBATCH --output=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/belebele/%x_%j.out
#SBATCH --error=/scratch/project_2005099/members/zihao/slurmlog/mixing_ablation_eval/belebele/%x_%j.err
#SBATCH --partition=gpusmall
#SBATCH --nodes=1
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8000
#SBATCH --gres=gpu:a100:1
#SBATCH --account=project_2008161

start_time=$(date +%s)
echo "Job started at: $(date)"

# Load environment
source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_2005099/members/zihao/env/harness

# Model checkpoints and corresponding task files
declare -A models
models=(
    # ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Bilingual-Altruistic/checkpoint-5500"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Bilingual-Code-Altruistic/checkpoint-6500"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Bilingual-Code-Selfish/checkpoint-5000"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Bilingual-Code-Stagnant/checkpoint-4000"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Bilingual-Selfish/checkpoint-4000"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Bilingual-Stagnant/checkpoint-3500"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Monolingual-Altruistic/checkpoint-7500"]="./altruistic_langs.txt"
    ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Monolingual-Code-Altruistic/checkpoint-8000"]="./altruistic_langs.txt"
    ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Monolingual-Code-Selfish/checkpoint-4000"]="./selfish_langs.txt"
    ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Monolingual-Code-Stagnant/checkpoint-5500"]="./stagnant_langs.txt"
    ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Monolingual-Selfish/checkpoint-3500"]="./selfish_langs.txt"
    ["/scratch/project_2008161/members/zihao/models/Llama-2-7B-Monolingual-Stagnant/checkpoint-5000"]="./stagnant_langs.txt"

    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Bilingual-Altruistic/checkpoint-4000"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Bilingual-Code-Altruistic/checkpoint-5000"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Bilingual-Code-Selfish/checkpoint-4500"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Bilingual-Code-Stagnant/checkpoint-3500"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Bilingual-Selfish/checkpoint-3500"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Bilingual-Stagnant/checkpoint-3000"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Monolingual-Altruistic/checkpoint-5500"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Monolingual-Code-Altruistic/checkpoint-6000"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Monolingual-Code-Selfish/checkpoint-3500"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Monolingual-Code-Stagnant/checkpoint-3500"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Monolingual-Selfish/checkpoint-3000"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Llama-3.1-8B-Monolingual-Stagnant/checkpoint-3000"]="./stagnant_langs.txt"

    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Bilingual-Altruistic/checkpoint-5000"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Bilingual-Code-Altruistic/checkpoint-5500"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Bilingual-Code-Selfish/checkpoint-4500"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Bilingual-Code-Stagnant/checkpoint-3500"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Bilingual-Selfish/checkpoint-4000"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Bilingual-Stagnant/checkpoint-3000"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Monolingual-Altruistic/checkpoint-6500"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Monolingual-Code-Altruistic/checkpoint-7000"]="./altruistic_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Monolingual-Code-Selfish/checkpoint-4000"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Monolingual-Code-Stagnant/checkpoint-5000"]="./stagnant_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Monolingual-Selfish/checkpoint-3500"]="./selfish_langs.txt"
    # ["/scratch/project_2008161/members/zihao/models/Viking-7B-Monolingual-Stagnant/checkpoint-4500"]="./stagnant_langs.txt"
)

# Base output directory
output_base="/scratch/project_2005099/members/zihao/mala/mixing-ablation/evaluation/Belebele/Results_3shots"

# Iterate over models and tasks
for model in "${!models[@]}"; do
    task_file="${models[$model]}"

    while IFS= read -r task; do
        # Create output path dynamically
        model_name="$(basename $(dirname "$model"))"
        checkpoint_name="$(basename "$model")"
        output_dir="${output_base}/${model_name}/${checkpoint_name}/${task}"
        mkdir -p "$output_dir"

        echo "Running evaluation for model: $model on task: $task"
        lm_eval --model hf \
            --model_args pretrained="$model" \
            --tasks "$task" \
            --num_fewshot 3 \
            --device cuda:0 \
            --batch_size 4 \
            --output_path "$output_dir" \
            --seed 42
    done <"$task_file"
done

end_time=$(date +%s)
echo "Job ended at: $(date)"

duration=$((end_time - start_time))
echo "Job duration: $(date -u -d @${duration} +%T)"
