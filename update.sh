#!/bin/sh

set_env() {
    echo "$1=$2" >>$GITHUB_ENV
    export $1=$2
}

GITHUB_API_LATEST="https://api.github.com/repos/gedoor/legado/releases/latest"

APP_LATEST_BODY="/opt/latest.md"
curl -s $GITHUB_API_LATEST | jq .body -r >$APP_LATEST_BODY
sed -e 's/^/> &/' \
    -e '1i\<!--start-->' \
    -e '$a\<!--end-->' \
    -e 's/\r//' \
    $APP_LATEST_BODY -i
sed -e '/<!--start-->/,/<!--end-->/d' \
    -e '10r\'"$APP_LATEST_BODY"'' \
    -e "7c\最新构建下载： *上次构建于 $APP_LATEST_CHECK*" \
    -e "9c\* [legado-$APP_LATEST_TAG](https://github.com/0x152a/legado-Build/releases/latest)" \
    README.md -i
sed "1i\$APP_LATEST_TAG" .lastcheck -i

set_env APP_LATEST_BODY $APP_LATEST_BODY
set_env TAG_NAME "legado-$APP_LATEST_TAG"
set_env FILES "$OUTPUT_PATH/*"
git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "github-actions[bot]"
git add .lastcheck
git add README.md
git commit -m "$APP_NAME-$APP_LATEST_TAG release"
