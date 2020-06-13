#!/bin/bash

env=$1

echo """
set -eu
set -o pipefail
cd platform
git --no-pager diff
git stash save "Deploy $(date '+%Y-%M-%d %H:%M:%S')"
git checkout .
git fetch -pv
git pull
docker-compose pull app
docker-compose up -d app
exit 0
""" | ssh -t -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master@${env}.huelladigital.ayudadigital.org bash -
