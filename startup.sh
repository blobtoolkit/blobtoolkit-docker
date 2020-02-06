#!/bin/bash

# bash /opt/conda/bin/activate btk_env

if [[ ! -z $VIEWER ]]; then
  if [[ -s "/blobtoolkit/conf/.env" ]]; then
    cp /blobtoolkit/conf/.env /blobtoolkit/viewer/.env
  fi
  cd /blobtoolkit/viewer
  npm start &
  npm run client &
fi

tail -f /dev/null
