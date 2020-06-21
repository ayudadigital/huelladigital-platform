#!/bin/bash

set -eu

# Initialize
cd "$(dirname "$0")/../.."

# @description Install item assets
#
# @example
#   assets-install
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode The result of the assets installation
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function assets-install() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Install assets"
    helpMessage=$(cat <<EOF
Install platform assets:

* Create all platform pieces directories with all permissions (777)
* Generate router self-signed test certificate if not exits
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
            echo "# Create data directories"
            SAVE_UMASK=$(umask)
            umask 0000
            mkdir -p data/db data/router/etc/letsencrypt
            umask "${SAVE_UMASK}"
            cp -n vault/.env.local .env || true
            source .env
            devDomain="dev.huelladigital.ayudadigital.org"
            CERTFILE="data/router/usr/local/etc/haproxy/certs/${devDomain}.pem"
            if [ ! -f $CERTFILE ] && [ $PROFILE == "dev" ]; then
                echo "# Generating self-signed certificate"
                tempdir=$(mktemp -d)
                openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
                    -subj "/C=ES/ST=Ayudadigital/L=Huelladigital/O=Dis/CN=${devDomain}" \
                    -keyout "${tempdir}/${devDomain}.key" -out "${tempdir}/${devDomain}.cert"
                cat "${tempdir}"/${devDomain}.* > "${tempdir}/${devDomain}.pem"
                cp -n "${tempdir}/${devDomain}.pem" "${CERTFILE}"
                rm -f "${tempdir}"/${devDomain}.*
                rmdir "${tempdir}"
            fi
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
assets-install "$@"
