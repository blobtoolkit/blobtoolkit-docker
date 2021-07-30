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

  export WORKDIR=/blobtoolkit/datasets/$ASSEMBLY

  if [[ ! -f "$WORKDIR/config.yaml" ]]; then
    echo "ERROR: unable to locate configuration file '$WORKDIR/config.yaml'"
    exit 1
  fi
  
  if [[ -z $THREADS ]]; then
    export THREADS=32
  fi

  if [[ ! -z $DRYRUN ]]; then
    DRYRUN="-n"
  fi

  if [[ -z $TOOL ]]; then
    TOOL="blobtoolkit"
  fi

  snakemake -p $DRYRUN \
            -j $THREADS \
            --directory $WORKDIR/$TOOL \
            --configfile $WORKDIR/config.yaml \
            --latency-wait 60 \
            --rerun-incomplete \
            --stats $WORKDIR/$TOOL.stats \
            -s /blobtoolkit/pipeline/$TOOL.smk

  if [ $? -ne 0 ];then
    echo "ERROR: failed to run snakemake pipeline"
    exit 1
  fi

  if [[ ! -z $TRANSFER ]]; then
    /blobtoolkit/pipeline/scripts/transfer_completed.py \
        --in $WORKDIR \
        --out /blobtoolkit/output
    
    if [ $? -ne 0 ];then
      echo "ERROR: failed to transfer completed files"
      exit 1
    fi
  fi
fi


