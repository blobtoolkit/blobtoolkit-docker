#!/bin/bash

if [[ ! -z $VIEWER ]]; then
  if [[ -s "/blobtoolkit/conf/.env" ]]; then
    cp /blobtoolkit/conf/.env /blobtoolkit/viewer/.env
  fi
  cd /blobtoolkit/viewer
  npm start &
  sleep 5
  npm run client &
fi

tail -f /dev/null
