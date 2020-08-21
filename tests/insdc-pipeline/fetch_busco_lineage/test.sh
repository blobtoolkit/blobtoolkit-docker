#!/usr/bin/bash

cd /tmp/insdc-pipeline/run_busco4

LINEAGE=actinopterygii_odb10

busco -f \
      -i /tests/blobtools2/shared_files/minimal.fasta \
      -o $LINEAGE \
      -l $LINEAGE \
      -m geno \
      -c 1 > $LINEAGE.log 2>&1 && \

mv run_$LINEAGE/full_table.tsv UELW01.busco.$LINEAGE.tsv && \

mv UELW01_$LINEAGE/run_$LINEAGE/short_summary.txt UELW01.busco.$LINEAGE.txt && \

rm -rf UELW01_$LINEAGE && 

cat short_summary.txt &&

exit 0 || 

cat $LINEAGE.log

ls -lh /tmp/insdc-pipeline/run_busco4/busco_downloads/lineages/actinopterygii_odb10

exit 1
