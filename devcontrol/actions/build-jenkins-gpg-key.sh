#!/bin/bash

set -eu

# Initialize
cd "$(dirname "$0")/../.."

# @description Build GPG key
#
# @example
#   build-gpg-key
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode The result of the assets installation
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function build-jenkins-gpg-key() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Build GPG key for Jenkins"
    helpMessage=$(cat <<EOF
Build GPG key for Jenkins:

* Build the GPG key using ayudadigital/gp-jenkins docker image
* Put the files within "vault" folder
  - private.asc => The private key. Create as a credential in Jenkins
  - public.asc  => The public key. Add it to git-secret
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
            echo "# Create keys"
            docker run --rm -u $(id -u):$(id -g) --entrypoint="" -v "$(pwd)/vault:/vault" ayudadigital/gp-jenkins \
                   bash -c /vault/docker-build-jenkins-gpg-key.sh
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
build-jenkins-gpg-key "$@"
