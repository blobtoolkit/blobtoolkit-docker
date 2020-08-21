#!/usr/bin/bash

blobtools add \
    --hits /tests/blobtools2/shared_files/minimal.blast.out \
    --taxrule bestsum \
    --taxdump /blobtoolkit/databases/ncbi_taxdump \
    /tmp/create_dataset_with_meta &&

[[ -s /tmp/create_dataset_with_meta/bestsum_positions.json ]] &&

exit 0 || exit 1
