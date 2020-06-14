#!/bin/bash

set -e

# Initialize
cd "$(dirname "$0")/../.."

# @description Operate [start, stop, destroy] all services and products
#
# @example
#   platform start
#   platform stop 
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode 0 operation sucesful
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function platform() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Operate [start, stop or destroy] all platform services"
    helpMessage=$(cat <<EOF
Start, stop or destroy all platform services

Usage:

$ devcontrol start # Will start all services

[...]

$ devcontrol stop # Will stop all services

[...]

$ devcontrol destroy # Will remove all related platform items: containers, networks and volumes

[...]

EOF
)
    # Task choosing
    read -r -a param <<< "$1"
    action=${param[0]}

    case ${action} in
        brief)
            showBriefMessage "${FUNCNAME[0]}" "$briefMessage"
            ;;
        help)
            showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
            ;;
        exec)
            if [ ${#param[@]} -lt 2 ]; then
                echo "ERROR - You should specify the action type: [start] or [stop]"
                echo
                showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
                exit 1
            fi
            platformAction=${param[1]}
            case ${platformAction} in
                cleanup)
                    # Cleanup
                    echo "# Cleanup (void)"
                    ;;
                start)
                    docker-compose up -d
                    ;;
                stop)
                    docker-compose stop
                    ;;
                destroy)
                    docker-compose down -v
                    ;;
                *)
                    echo "ERROR - Unknown action [${platformAction}], use [start] or [stop]"
                    echo
                    showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
                    exit 1
            esac
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
platform "$*"
