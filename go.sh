#!/bin/sh

set_env() {
    echo "$1=$2" >>$GITHUB_ENV
    export $1=$2
}

device=$DEVICE
if [ -z "$device" ]; then
    device=main
fi
mode=$MODE
if [ -z "$mode" ]; then
    mode=normal
fi
set_env APP_MODE $mode
set_env APP_GIT_URL "https://github.com/gedoor/legado.git"
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
    set_env APP_WORKSPACE "/opt/$APP_NAME-$APP_MODE"
    echo build for main device
    ;;

v2)
    set_env OUTPUT_NAME_SUFFIX "v2"
    set_env APP_LAUNCH_NAME "阅读-s"
    set_env APP_WEBDAV_PATH "reading-s"
    set_env APP_PAKAGE_NAME_SUFFIX "releaseS"
    set_env APP_NAME "legado-s"
    set_env APP_WORKSPACE "/opt/$APP_NAME-$APP_MODE"
    echo build for v2 device
    ;;

esac

cd $WORKSPACE
source $WORKSPACE/build.sh

set_env APK_NAME $APP_OUTPUT_NAME
set_env APP_OUTPUT_NAME $APP_OUTPUT_NAME
set_env APK $APP_BUILD_APK
