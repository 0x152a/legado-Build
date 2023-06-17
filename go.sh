#!/bin/sh

set_env() {
    echo "$1=$2" >>$GITHUB_ENV
    export $1=$2
}

set device=${DEVICE?:main}
set_env APP_MODE=${MODE?:normal}
set_env APP_GIT_URL "https://ghproxy.com/https://github.com/gedoor/legado.git"
set_env WORKSPACE $GITHUB_WORKSPACE
# set_env WORKSPACE $(dirname $(readlink -f "$0"))
set_env OUTPUT_PATH "/opt/output"
set_env INPUT_PATH "$WORKSPACE/input"

case "$device" in
main)
    set_env OUTPUT_NAME_SUFFIX "main"
    set_env APP_LAUNCH_NAME "阅读"
    set_env APP_WEBDAV_PATH "reading"
    set_env APP_PAKAGE_NAME_SUFFIX "releaseX"
    set_env APP_NAME "legado"
    set_env APP_WORKSPACE "/opt/$APP_NAME"
    echo build for main device
    ;;

v2)
    set_env OUTPUT_NAME_SUFFIX "v2"
    set_env APP_LAUNCH_NAME "阅读-s"
    set_env APP_WEBDAV_PATH "reading-s"
    set_env APP_PAKAGE_NAME_SUFFIX "releaseS"
    set_env APP_NAME "legado-s"
    set_env APP_WORKSPACE "/opt/$APP_NAME"
    echo build for v2 device
    ;;

esac

cd $WORKSPACE
source $WORKSPACE/build.sh

set_env APK_NAME $APP_OUTPUT_NAME
set_env APK $APP_BUILD_APK
