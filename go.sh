#!/bin/sh

set_env() {
    echo "$1=$2" >>$GITHUB_ENV
    export $1=$2
}

# 1

set_env OUTPUT_NAME_SUFFIX "main"

set_env APP_GIT_URL "https://ghproxy.com/https://github.com/gedoor/legado.git"
set_env APP_LAUNCH_NAME "阅读"
set_env APP_WEBDAV_PATH "reading"
set_env APP_PAKAGE_NAME_SUFFIX "releaseX"

set_env APP_NAME "legado"
set_env WORKSPACE $GITHUB_WORKSPACE
# set_env WORKSPACE $(dirname $(readlink -f "$0"))
set_env APP_WORKSPACE "/opt/$APP_NAME"
set_env INPUT_PATH "$WORKSPACE/input"
set_env OUTPUT_PATH "/opt/output"

source $WORKSPACE/build.sh

set_env APK_1_NAME $APP_OUTPUT_NAME
set_env APK_1 $APP_BUILD_APK


# 2
cd $WORKSPACE

set_env OUTPUT_NAME_SUFFIX "sex"
set_env APP_NAME "legado-s"
set_env APP_LAUNCH_NAME "阅读-s"
set_env APP_WEBDAV_PATH "reading-s"
set_env APP_PAKAGE_NAME_SUFFIX "releaseS"
set_env APP_WORKSPACE "/opt/$APP_NAME"

source $WORKSPACE/build.sh

set_env APK_2_NAME $APP_OUTPUT_NAME
set_env APK_2 $APP_BUILD_APK
