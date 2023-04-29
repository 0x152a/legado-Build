#!/bin/sh

set_env() {
    echo "$1=$2" >>$GITHUB_ENV
    export $1=$2
}

GITHUB_API_LATEST="https://api.github.com/repos/gedoor/legado/releases/latest"

set_env WORKSPACE $GITHUB_WORKSPACE
LatestTag=$(curl -s $GITHUB_API_LATEST | jq .tag_name -r)
LatestCheck=$(date -u -d"+8 hour" "+%Y-%m-%d %H:%M:%S")
LastTag=$(cat $WORKSPACE/.lastcheck | sed -n 1p)
echo LastTag is $LastTag

version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
if version_gt $LatestTag $LastTag; then
    set_env HAS_NEWER_VERSION "TRUE"
    set_env APP_LATEST_TAG $LatestTag
    set_env APP_LATEST_CHECK $LatestCheck
    set_env OUTPUT_NAME_SUFFIX $OUTPUT_NAME_SUFFIX-$LatestTag
    echo Found newer version: $LatestTag
else
    set_env HAS_NEWER_VERSION "FALSE"
fi
