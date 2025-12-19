#!/bin/bash
##############################
# SBATCH CONFIGURATION
##############################

#SBATCH --job-name=landseer_run
#SBATCH --output=landseer_out_%j.txt
#SBATCH --error=landseer_err_%j.txt

#SBATCH --partition=a30            # Your group has A30 GPUs
#SBATCH --account=zghodsi          # IMPORTANT: your lab account
#SBATCH --qos=normal               # normal priority

#SBATCH --nodes=1
#SBATCH --gpus-per-node=1          # 1 GPU (A30)
#SBATCH --cpus-per-task=8
#SBATCH --mem=60G                  # Enough RAM
#SBATCH --time=04:00:00            # Max job time allowed for normal QOS

##############################
# ENVIRONMENT SETUP
##############################

echo "Job started on $(hostname) at $(date)"

module load miniconda/23.3.1-py311
conda activate landseer311

# Apptainer cache configuration
export APPTAINER_CACHEDIR=/scratch/gilbreth/$USER/apptainer_cache
export APPTAINER_TMPDIR=/scratch/gilbreth/$USER/apptainer_tmp
mkdir -p "$APPTAINER_CACHEDIR" "$APPTAINER_TMPDIR"

cd /scratch/gilbreth/$USER/Landseer

##############################
# RUN LANDSEER PIPELINE
##############################

poetry run landseer \
    -c configs/pipeline/no_attack/one_tool_per_stage.yaml \
    -a configs/attack/test_config_1.yaml

echo "Job finished at $(date)"
