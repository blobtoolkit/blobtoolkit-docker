#!/bin/bash

(
eval "$(conda shell.bash hook)"
conda activate busco4_env &&
export AUGUSTUS_CONFIG_PATH=`pwd`/augustus_conf &&
if [ ! -d $AUGUSTUS_CONFIG_PATH ]; then
  cp -r /home/blobtoolkit/miniconda3/envs/busco4_env/config $AUGUSTUS_CONFIG_PATH
fi &&
PYTHONPATH= /home/blobtoolkit/miniconda3/envs/busco4_env/bin/busco "$@"
conda deactivate
)

