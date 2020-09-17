#!/usr/bin/bash

ASSEMBLY=minimal

cd /tmp/insdc-pipeline/fetch_fastq

snakemake -p \
          --directory ./ \
          --configfile /tests/insdc-pipeline/shared_files/fetch_fastq.yaml \
          --latency-wait 60 \
          --rerun-incomplete \
          -j 1 \
          -s /blobtoolkit/insdc-pipeline/tests/test_fetch_fastq.smk &&

ls -lh &&

cd - && exit 0 || 

cat logs/$ASSEMBLY/fetch_fastq/*.log

cd - && exit 1
