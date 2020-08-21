#!/usr/bin/bash

ASSEMBLY=minimal

LINEAGE=actinopterygii_odb10

cd /tmp/insdc-pipeline/run_busco4

cp /tests/insdc-pipeline/shared_files/$ASSEMBLY.fasta ./

snakemake -p \
          --directory ./ \
          --configfile /tests/insdc-pipeline/shared_files/busco4.yaml \
          --latency-wait 60 \
          --rerun-incomplete \
          --stats $ASSEMBLY.replaceHits.stats \
          -j 1 \
          -s /blobtoolkit/insdc-pipeline/tests/test_run_busco4.smk \
          --resources btk=1

cat minimal.busco.$LINEAGE.txt &&

cd - && exit 0 || 

cat logs/$ASSEMBLY/run_busco/$LINEAGE.log

ls -lh /tmp/insdc-pipeline/run_busco4/busco_downloads/lineages/actinopterygii_odb10

cd - && exit 1
