#!/usr/bin/bash

rm -rf /tmp/create_dataset_with_meta &&

blobtools create \
    --fasta /tests/blobtools2/shared_files/minimal.fasta \
    --meta /tests/blobtools2/shared_files/minimal.yaml \
    --taxid 3702 \
    --taxdump /blobtoolkit/databases/ncbi_taxdump \
    /tmp/create_dataset_with_meta &&

PHYLUM=$(jq -r '.taxon | .phylum' /tmp/create_dataset_with_meta/meta.json) &&

[[ "$PHYLUM" == "Streptophyta" ]] &&

exit 0 || exit 1
