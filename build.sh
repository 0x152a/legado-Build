#!/bin/sh

set_env() {
    echo "$1=$2" >>$GITHUB_ENV
    export $1=$2
}

if [ ! -d "$OUTPUT_PATH" ]; then
    mkdir $OUTPUT_PATH
fi
if [ -d "$APP_WORKSPACE" ]; then
    rm -rdf $APP_WORKSPACE
fi

git clone $APP_GIT_URL $APP_WORKSPACE
cd $APP_WORKSPACE
LatestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
set_env APP_LATEST_TAG $LatestTag
set_env APP_OUTPUT_NAME "$APP_NAME-$LatestTag-$OUTPUT_NAME_SUFFIX"

source $WORKSPACE/customise.sh
echo Completed Customise

# build apk with gradle
cd $APP_WORKSPACE
chmod +x gradlew
./gradlew assembleAppRelease --build-cache --parallel

while :; do
    sleep 1
    APP_BUILD_APK=$(find $APP_WORKSPACE/app/build/outputs/apk -name "*.apk")
    if ! test -z "$APP_BUILD_APK"; then
        break
    fi
done
echo build apk $APP_BUILD_APK
if [ -f $APP_BUILD_APK ]; then
    echo Move output file $APP_BUILD_APK to $OUTPUT_PATH/$APP_OUTPUT_NAME.apk
    mv $APP_BUILD_APK "$OUTPUT_PATH/$APP_OUTPUT_NAME.apk"
    set_env APP_BUILD_APK "$OUTPUT_PATH/$APP_OUTPUT_NAME.apk"
else
    set_env APP_BUILD_APK $APP_BUILD_APK
fi
# output
echo "Build completed => $APP_BUILD_APK"
