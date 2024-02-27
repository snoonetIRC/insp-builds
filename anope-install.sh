#!/bin/bash
set -e
set -x

BASE_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

add_snoonet_module() {
    ln -s "$PWD/anope-modules-master/modules/$1" "$PWD/modules/third/$1"
}

add_vendor_extra() {
    pushd "$PWD/modules" || exit 1
    ln -s "extra/$1" "$1"
    popd || exit 1
}

install_extras() {
    add_snoonet_module 'hs_reghost.cpp'
    add_snoonet_module 'os_server_news.cpp'
    add_snoonet_module 'm_store_server.cpp'
    add_snoonet_module 'm_eventlog.cpp'
    add_snoonet_module 'json_api.h'
    add_snoonet_module 'mail_template.h'
    add_snoonet_module 'snoo_types.h'
    add_snoonet_module 'm_token_auth.h'
    add_snoonet_module 'm_register_api'

    add_vendor_extra 'm_mysql.cpp'
    add_vendor_extra 'm_ssl_gnutls.cpp'
    add_vendor_extra 'm_ssl_openssl.cpp'
    add_vendor_extra 'm_regex_posix.cpp'
    add_vendor_extra 'm_regex_pcre.cpp'
}

install() {
    local version="$1"
    local version_name="anope-${version}"
    cd "${BASE_DIR:?}/${version_name}" || exit 1
    install_extras
    cat << EOF > config.cache
UMASK=022
INSTDIR="$PWD/services"
EOF

    export CXXFLAGS="-std=c++11"
    ./Config -nointro -quick
    cd build || exit 1
    make --jobs "$(nproc)" && make install
}

VERSION="${1?No install version specified, exiting...}"

install "${VERSION}"
