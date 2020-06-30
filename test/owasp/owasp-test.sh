#!/bin/bash

set -eux

initialize() {
    cd "$(dirname "$0")/../.."
    workspaceID=$(pwd|md5sum|cut -f 1 -d " ")
    CTID=""
}

buildTestDockerImage() {
    docker build -t "test_${workspaceID}" test/owasp
}

startDockerDindEnvironment() {
    CTID=$(docker run --privileged -i -d \
               -v "dind_${workspaceID}:/var/lib/docker:delegated" \
               -v "$(pwd):$(pwd):rw,z" \
               -w "$(pwd)" \
               "test_${workspaceID}")
    docker exec -i "${CTID}" bash -c "while [ ! -S /var/run/docker.sock ]; do sleep 2; done; chmod 666 /var/run/docker.sock"
}

executeOwaspTestWithinDocker() {
    docker exec -i -u "$(id -u):$(id -g)" "${CTID}" test/owasp/docker-owasp-test.sh
}

destroyDockerDindEnvironment() {
    docker rm -f "${CTID}"
}

compareResultsWithSeed() {
    diff activescan-report.html test/owasp/activescan-report.html
    diff baselinescan-report.txt test/owasp/baselinescan-report.txt
}

# Main
initialize
buildTestDockerImage
startDockerDindEnvironment
executeOwaspTestWithinDocker
destroyDockerDindEnvironment
compareResultsWithSeed