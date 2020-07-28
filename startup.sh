#!/bin/bash

if [[ ! -z $VIEWER ]]; then
  if [[ -s "/blobtoolkit/conf/.env" ]]; then
    cp /blobtoolkit/conf/.env /blobtoolkit/viewer/.env
  fi
  cd /blobtoolkit/viewer
  npm start &
  sleep 5
  npm run client &

  tail -f /dev/null
fi

if [[ ! -z $ASSEMBLY ]]; then
  if [[ -z $THREADS ]]; then
    export THREADS=32
  fi
  if [[ -z $MAXCORE ]]; then
    export MAXCORE=16
  fi
  if [[ -z $MULTICORE ]]; then
    export MULTICORE=8
  fi
  if [[ ! -f "/blobtoolkit/datasets/$ASSEMBLY.yaml" ]]; then
    echo "ERROR: unable to locate configuration file '/blobtoolkit/datasets/$ASSEMBLY.yaml'"
    exit 1
  fi
  if [[ ! -z $DRYRUN ]]; then
    DRYRUN="-n"
  fi

  # Check the working directory is unlocked in case a previous run failed
  snakemake -p \
            -j 1 \
            --directory /blobtoolkit/datasets \
            --configfile /blobtoolkit/datasets/$ASSEMBLY.yaml \
            -s /blobtoolkit/insdc-pipeline/Snakefile \
            --unlock

  if [ $? -ne 0 ];then
    echo "ERROR: failed while unlocking working directory"
    exit 1
  fi

  if [[ -z $VALIDATE_ONLY ]]; then
    # Run pipeline
    export AUGUSTUS_CONFIG_PATH=/blobtoolkit/datasets/augustus_conf
    if [ ! -d $AUGUSTUS_CONFIG_PATH ]; then
      cp -r /home/blobtoolkit/miniconda3/envs/busco4_env/config $AUGUSTUS_CONFIG_PATH
    fi
    snakemake -p $DRYRUN \
              --directory /blobtoolkit/datasets \
              --configfile /blobtoolkit/datasets/$ASSEMBLY.yaml \
              --latency-wait 60 \
              --rerun-incomplete \
              --stats $ASSEMBLY.replaceHits.stats \
              -j $THREADS \
              -s /blobtoolkit/insdc-pipeline/Snakefile \
              --resources btk=1

    if [ $? -ne 0 ];then
      echo "ERROR: failed during pipeline"
      exit 1
    fi
  fi

  if [[ -z $PIPELINE_ONLY ]]; then
    # Validate and transfer
    snakemake -p $DRYRUN \
              --directory /blobtoolkit/datasets/ \
              --configfile /blobtoolkit/datasets/$ASSEMBLY.yaml \
              --latency-wait 60 \
              --rerun-incomplete \
              --stats $ASSEMBLY.snakemake.stats \
              -j $THREADS \
              -s /blobtoolkit/insdc-pipeline/transferCompleted.smk \
              --resources btk=1 \
              --config destdir=/blobtoolkit/output

    if [ $? -ne 0 ];then
      echo "ERROR: failed during transferCompleted"
      exit 1
    fi
  fi
fi


