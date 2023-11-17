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
    if [[ "$1" == "$2" ]]; then
        return 1
    fi
    local IFS=.
    local i v1=($1) v2=($2)
    
    # Fill empty fields in v1 with zeros
    for ((i=${#v1[@]}; i<${#v2[@]}; i++)); do
        v1[i]=0
    done

    for ((i=0; i<${#v1[@]}; i++)); do
        if ((10#${v1[i]} > 10#${v2[i]})); then
            return 0
        elif ((10#${v1[i]} < 10#${v2[i]})); then
            return 1
        fi
    done

    return 1
}

if [ -z "$LastTag" -o $(version_gt $APP_LATEST_TAG $LastTag) ]; then
    set_env HAS_NEWER_VERSION "TRUE"
    echo Found newer version: $APP_LATEST_TAG
else
    set_env HAS_NEWER_VERSION "FALSE"
fi
