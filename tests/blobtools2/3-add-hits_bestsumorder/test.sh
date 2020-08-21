#!/usr/bin/bash

blobtools add \
    --hits /tests/blobtools2/shared_files/minimal.blast.out \
    --taxrule bestsumorder \
    --taxdump /blobtoolkit/databases/ncbi_taxdump \
    /tmp/create_dataset_with_meta &&

[[ -s /tmp/create_dataset_with_meta/bestsumorder_positions.json ]] &&

exit 0 || exit 1
