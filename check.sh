#!/bin/sh

set_env() {
    echo "$1=$2" >>$GITHUB_ENV
    export $1=$2
}

GITHUB_API_LATEST="https://api.github.com/repos/gedoor/legado/releases/latest"

set_env WORKSPACE $GITHUB_WORKSPACE
LastTag=$(cat $WORKSPACE/.lastcheck | sed -n 1p)
set_env APP_LATEST_TAG $(curl -s $GITHUB_API_LATEST | jq .tag_name -r)
set_env APP_LATEST_CHECK $(date -u -d"+8 hour" "+%Y-%m-%d %H:%M:%S")
set_env OUTPUT_NAME_SUFFIX $OUTPUT_NAME_SUFFIX-$LatestTag
echo LastTag is $LastTag, now is $APP_LATEST_TAG

version_gt() {
    local v1=$(echo "$1" | sed 's/^0*//')  # Remove leading zeros
    local v2=$(echo "$2" | sed 's/^0*//')
    test "$(echo "$v1\n$v2" | sort -V | head -n 1)" != "$v1"
}
if [ -z "$LastTag" -o $(version_gt $APP_LATEST_TAG $LastTag) ]; then
    set_env HAS_NEWER_VERSION "TRUE"
    echo Found newer version: $APP_LATEST_TAG
else
    set_env HAS_NEWER_VERSION "FALSE"
fi
