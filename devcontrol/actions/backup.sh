#!/bin/bash

set -e

# Initialize
cd "$(dirname "$0")"/../.. || exit 1

# @description Do backup of all docker containers (products and services) and all docker volumes
#
# @example
#   backup
#
# @exitcode 0 operation successsful
#
function backup() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Platform backup"
    helpMessage=$(cat <<EOF
[TODO] Do backup of all docker volumes

Usage:

$ devcontrol backup

[...]


EOF
)
    # Task choosing
    read -r -a param <<< "$1"
    action=${param[0]}

    case $action in
        brief)
            showBriefMessage "${FUNCNAME[0]}" "$briefMessage"
            ;;
        help)
            showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
            ;;
        exec)
            echo "To be implemented"
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
backup "$*"
