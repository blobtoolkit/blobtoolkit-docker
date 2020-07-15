#!/bin/bash

BT2_VERSION=$(blobtools --version)
if [ "$?" == "0" ]; then
  echo BlobTools2 version is $BT2_VERSION
else
  exit 1
fi

echo "All tests passed!"

exit 0
