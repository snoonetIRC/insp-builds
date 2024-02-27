#!/bin/bash
set -e

BASE_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
install() {
    ls -la
    return
}

VERSION="${1?No install version specified, exiting...}"

install "${VERSION}"
