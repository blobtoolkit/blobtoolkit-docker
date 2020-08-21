#!/usr/bin/bash

rm -rf /tmp/create_dataset &&

blobtools create \
    --fasta /tests/blobtools2/shared_files/minimal.fasta \
    /tmp/create_dataset &&

ls /tmp/create_dataset &&

exit 0 || exit 1
