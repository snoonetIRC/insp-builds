#!/bin/bash
set -e

BASE_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
install() {
    local version="$1"
    cd "anope-$version" || exit 1
    ls -la
    return
}

VERSION="${1?No install version specified, exiting...}"

install "${VERSION}"
