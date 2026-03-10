#!/bin/bash
#SBATCH --job-name=landseer_run
#SBATCH --output=landseer_%j.out
#SBATCH --error=landseer_%j.err
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=60G
#SBATCH --gpus-per-node=1
#SBATCH --partition=a30
#SBATCH --account=zghodsi
#SBATCH --qos=normal

set -e

source /scratch/gilbreth/$USER/miniforge3/etc/profile.d/conda.sh
conda activate landseer311

export SCR=/scratch/gilbreth/$USER
export XDG_CACHE_HOME=$SCR/.cache
export APPTAINER_CACHEDIR=$SCR/apptainer_cache
export APPTAINER_TMPDIR=$SCR/apptainer_tmp
export TORCH_HOME=$SCR/.cache/torch
mkdir -p $XDG_CACHE_HOME $APPTAINER_CACHEDIR $APPTAINER_TMPDIR $TORCH_HOME

cd /scratch/gilbreth/$USER/Landseer

python -m landseer_pipeline.main \
  -c configs/pipeline/srihari_dawn_deploy.yaml \
  -a configs/attack/test_config_1.yaml \
  --log-level INFO \
  --data-dir /scratch/gilbreth/$USER/landseer_data \
  --log-dir /scratch/gilbreth/$USER/landseer_logs \
  --results-dir /scratch/gilbreth/$USER/landseer_results \
  --no-cache
