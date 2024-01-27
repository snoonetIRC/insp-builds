#!/bin/bash
set -e

BASE_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

vendor_extra() {
    ./configure --enable-extra "${1}"
}

# Third party extra (installed via modulemanager
third_extra() {
    ./modulemanager install "${1}"
}

apply_patch() {
    echo "Applying ${1} ..."
    wget -O - "${1}" | patch -p1
}

apply_patches() {
    echo "Applying patches";
}

install_extras() {
    # Modules that have third-party dependencies.
    vendor_extra 'm_regex_pcre'
    vendor_extra 'm_regex_posix'
    vendor_extra 'm_ssl_openssl'
    vendor_extra 'm_sslrehashsignal'

    # Modules that are in inspircd-contrib.
    ./modulemanager upgrade
    third_extra 'm_asciiswitch'
    third_extra 'm_dccblock'
    third_extra 'm_join0'
    third_extra 'm_joinpartsno'
    third_extra 'm_namedstats'
    third_extra 'm_require_auth'
    third_extra 'm_totp'
    third_extra 'm_globalmessageflood'
    third_extra 'm_slowmode'
}

install() {
    version="${1}"
    version_name="inspircd-${version}"
    url="https://codeload.github.com/inspircd/inspircd/tar.gz/v${version}"
    [ -d "${BASE_DIR:?}/${version_name}" ] && rm -r "${BASE_DIR:?}/${version_name}"
    wget -O - "${url}" | tar zx
    cd "${BASE_DIR:?}/${version_name}"
    install_extras
    apply_patches

    export CXXFLAGS="-std=c++11"
    ./configure --disable-auto-extras --prefix "${BASE_DIR:?}/run"
    make clean && make --jobs "$(nproc)" && make install
}

VERSION="${1}"

if [ "${VERSION}""x" = "x" ]; then
    echo "No install version specified, exiting..."
    exit 1
fi

install "${VERSION}"
