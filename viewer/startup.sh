#!/bin/ash

if [[ -s "/blobtoolkit/conf/.env" ]]; then
  cp /blobtoolkit/conf/.env /blobtoolkit/viewer/.env
fi
cd /blobtoolkit/viewer
npm run api &
sleep 5
npm run client &

tail -f /dev/null
exit