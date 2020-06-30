#!/bin/bash

set -eu

# @description Run bash linter
#
# @example
#   owasp-tests
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode The result of the shellckeck
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function owasp-tests() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Execute owasp tests"
    helpMessage=$(cat <<EOF
Run owasp tests

* Active Scan
* Baseline Scan

You will get two files:

- activescan-report.html
- baselinescan-report.txt

These files will be compared with the ones with the same name within "test/owasp" directory
The task will raise an error if there where diferences between them
EOF
)

    # Task choosing
    case $1 in
        brief)
            showBriefMessage "${FUNCNAME[0]}" "$briefMessage"
            ;;
        help)
            showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
            ;;
        exec)
            test/owasp/owasp-test.sh
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
owasp-tests "$@"
