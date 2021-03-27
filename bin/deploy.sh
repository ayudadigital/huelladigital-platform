#!/bin/bash

set -x

# Get target branch
env=$1
case $env in
    dev) TARGET_BRANCH="develop" ;;
    *)
        echo "Wrong environment $env. Aborting"
        exit 1
        ;;
esac

# Check env file
if [ ! -f "vault/.env.${env}" ]; then
    echo "The env file vault/.env.${env} does not exist. Aborting"
    exit 1
fi

# Copy and remove env file
rsync --remove-source-files -avpP -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" "vault/.env.${env}" "master@${env}.huelladigital.ayudadigital.org:~/huelladigital-platform/.env"

# Remote deploy
stashMessage="Deploy $(date '+%Y-%M-%d %H:%M:%S')"
echo """
set -eu
set -o pipefail
cd huelladigital-platform
git --no-pager diff
git stash save ${stashMessage}
git checkout ${TARGET_BRANCH}
git fetch -pv
git pull
docker-compose pull
docker-compose up -d
exit 0
""" | ssh -t -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "master@${env}.huelladigital.ayudadigital.org" bash -
