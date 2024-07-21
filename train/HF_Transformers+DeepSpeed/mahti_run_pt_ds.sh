#!/bin/bash
#SBATCH --job-name=pt
#SBATCH --output=/scratch/project_2005099/members/zihao/slurmlog/train/%x_%j.out
#SBATCH --error=/scratch/project_2005099/members/zihao/slurmlog/train/%x_%j.err
#SBATCH --partition=gpumedium
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:a100:4
#SBATCH --account=project_2005099

module load gcc/10.4.0 cuda/12.1.1

source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_2005099/members/zihao/env/llama_factory_env


CUDA_VISIBLE_DEVICES=0,1,2,3 torchrun --nproc_per_node 4 pretraining.py \
    --model_type bloom \
    --model_name_or_path bigscience/bloomz-560m \
    --train_file_dir ./data/pretrain \
    --validation_file_dir ./data/pretrain \
    --per_device_train_batch_size 3 \
    --per_device_eval_batch_size 3 \
    --do_train \
    --do_eval \
    --use_peft False \
    --seed 42 \
    --fp16 \
    --max_train_samples 20000 \
    --max_eval_samples 10 \
    --num_train_epochs 1 \
    --learning_rate 2e-4 \
    --warmup_ratio 0.05 \
    --weight_decay 0.01 \
    --logging_strategy steps \
    --logging_steps 10 \
    --eval_steps 50 \
    --evaluation_strategy steps \
    --save_steps 500 \
    --save_strategy steps \
    --save_total_limit 3 \
    --gradient_accumulation_steps 1 \
    --preprocessing_num_workers 1 \
    --block_size 128 \
    --group_by_length True \
    --output_dir outputs-pt-multiGPUs \
    --overwrite_output_dir \
    --ddp_timeout 30000 \
    --logging_first_step True \
    --target_modules all \
    --lora_rank 8 \
    --lora_alpha 16 \
    --lora_dropout 0.05 \
    --torch_dtype float16 \
    --device_map auto \
    --report_to tensorboard \
    --ddp_find_unused_parameters False \
    --gradient_checkpointing True \
    --deepspeed deepspeed_zero_stage2_config.json