#!/bin/bash

set -eux

initialize() {
    cd "$(dirname "$0")/../.."
}

cleanTestData() {
    docker-compose kill
    docker-compose down -v
    docker-compose run --rm db bash -c "rm -rf /var/lib/postgresql/data/*"
    rm -rf ./data/router/usr/local/etc/haproxy/certs/dev.huelladigital.ayudadigital.org.pem
    docker container prune -f
}

startHuelladigitalPlatform() {
    bin/devcontrol.sh assets-install
    cp -f vault/.env.local .env
    docker-compose pull
    docker-compose up -d
}

executeZapTests() {
    local network

    # Start zap container
    network=$(docker inspect "$(docker-compose ps -q router)" --format='{{range $k,$v := .NetworkSettings.Networks}} {{$k}} {{end}}'|tr -d " ")
    docker run --network "${network}" --name zap -u zap -d owasp/zap2docker-stable /zap/zap.sh -daemon -host 127.0.0.1 -port 8080 -config api.disablekey=true -config api.addrs.addr.regex=true -config api.addrs.addr.name=.* -config connection.timeoutInSecs=600
    docker exec -i zap zap-cli start

    # Execute active-scan
    zap_cli="docker exec -i zap zap-cli"
    $zap_cli open-url http://router
    $zap_cli active-scan http://router
    $zap_cli report -o /tmp/activescan-report.html -f html
    docker cp zap:/tmp/activescan-report.html activescan-report.html

    # Execute baseline-scan
    docker run --network "${network}" -i owasp/zap2docker-stable zap-baseline.py -t https://router > baselinescan-report.txt 2> /dev/null || true

    # Destroy zap container
    docker rm -f zap
}

# Main
initialize
cleanTestData
startHuelladigitalPlatform
executeZapTests
cleanTestData
