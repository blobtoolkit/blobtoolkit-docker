#!/bin/bash

sleep 2

BT2_VERSION=$(blobtools --version)
if [ "$?" == "0" ]; then
  echo BlobTools2 version is $BT2_VERSION
else
  exit 1
fi

PATTERN="${PATTERN:-*/*}"

for SCRIPT in /tests/${PATTERN}/test.sh; do
  TEST=$(echo $SCRIPT | sed 's:^/tests/::;s:/test\.sh$::')
  printf "Test $TEST...\r"
  mkdir -p /tmp/$TEST
  mkdir -p /tmp/log/$TEST
  (bash $SCRIPT) &> /tmp/log/$TEST/out
  if [[ $? -eq 0 ]]; then
    echo "PASSED"
    if [ ! -z "$DEBUG" ]; then
      echo "=============="
      echo "  Test output:"
      sed 's/^/  /' /tmp/log/$TEST/out
      echo "=============="
    fi
  else
    echo "FAILED"
    echo "=================="
    echo "  Test script was:"
    sed 's/^/  /' $SCRIPT
    echo "=============="
    if [ -s /tmp/log/$TEST/out ]; then
      echo "  Test output:"
      sed 's/^/  /' /tmp/log/$TEST/out
    else
      echo "  Test produced no output"
    fi
    exit 1
  fi
done

echo "All tests passed!"

exit 0
