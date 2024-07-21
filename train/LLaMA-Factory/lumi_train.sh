#!/bin/bash
#SBATCH --job-name=lumi_train
#SBATCH --output=/scratch/project_462000506/members/zihao/slurmlog/LLaMA-Factory/%x_%j.out
#SBATCH --error=/scratch/project_462000506/members/zihao/slurmlog/LLaMA-Factory/%x_%j.err
#SBATCH --partition=standard-g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=4
#SBATCH --time=12:00:00
#SBATCH --account=project_462000647

module load LUMI/23.09  partition/G
module load rocm/5.6.1

source /users/lizihao1/miniconda3/etc/profile.d/conda.sh
conda activate /scratch/project_462000506/members/zihao/llama_factory_env


FORCE_TORCHRUN=1 llamafactory-cli train /scratch/project_462000506/members/zihao/train/LLaMA-Factory/examples/train_full/llama3_full_pt_ds2.yaml
