#!/bin/bash
#SBATCH --job-name=mahti_train
#SBATCH --output=/scratch/project_2005099/members/zihao/slurmlog/train/%x_%j.out
#SBATCH --error=/scratch/project_2005099/members/zihao/slurmlog/train/%x_%j.err
#SBATCH --partition=gpumedium
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:a100:4
#SBATCH --account=project_2005099
#SBATCH --mail-type=ALL
#SBATCH --mail-user=zihao.li@helsinki.fi

module load gcc/10.4.0 cuda/12.1.1

source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_2005099/members/zihao/env/llama_factory_env

nvcc --version
echo $CUDA_HOME

FORCE_TORCHRUN=1 llamafactory-cli train /scratch/project_2005099/members/zihao/LLaMA-Factory/examples/train_full/llama3_full_pt_ds2.yaml
