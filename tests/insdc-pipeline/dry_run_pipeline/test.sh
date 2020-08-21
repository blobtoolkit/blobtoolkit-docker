#!/usr/bin/bash

export ASSEMBLY=WJFA01
cp /tests/insdc-pipeline/shared_files/$ASSEMBLY.yaml /blobtoolkit/datasets/
DRYRUN=true PIPELINE_ONLY=true /blobtoolkit/startup.sh  &&
rm /blobtoolkit/datasets/$ASSEMBLY.yaml &&
exit 0 || 
rm /blobtoolkit/datasets/$ASSEMBLY.yaml
exit 1
