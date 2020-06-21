#!/bin/bash
export HOME=/tmp
cat >/tmp/keygen.txt <<EOF
    %echo Generating a basic OpenPGP key
    Key-Type: DSA
    Key-Length: 1024
    Subkey-Type: ELG-E
    Subkey-Length: 1024
    Name-Real: Ayudadigital huelladigital-platform
    Name-Email: huelladigital-platform@jenkins.ayudadigital.org
    Expire-Date: 0
    %no-protection
    %commit
    %echo done
EOF
gpg --batch --generate-key /tmp/keygen.txt
gpg --batch --yes --output /vault/public.asc --export --armor huelladigital-platform@jenkins.ayudadigital.org
gpg --batch --yes --output /vault/private.asc --export-secret-key --armor huelladigital-platform@jenkins.ayudadigital.org
