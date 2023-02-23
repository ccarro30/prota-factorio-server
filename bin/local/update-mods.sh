#!/bin/bash

MOD_DIRECTORY="/home/ccarro/.factorio/mods"
USERNAME=""
TOKEN=""

MODS=( $(find $MOD_DIRECTORY -regex '.+[0-9]+\.[0-9]+\.[0-9]+\.zip$' -exec basename {} \; | sed 's/ /*/g') )

for MOD in ${MODS[@]}
do
    MOD=$(echo $MOD | sed 's/*/ /g')
    NAME=$(echo $MOD | awk -F_ '{NF--; print}')
    LOCAL_VERSION=$(echo $MOD | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

    MOD_RESPONSE=$(curl -s "https://mods.factorio.com/api/mods/$NAME")
    MOD_FAC_VERSIONS=$(echo "$MOD_RESPONSE" | jq '[.releases[].info_json.factorio_version] | unique')
    MOD_REMOTE_VERSION_LATEST=$(echo "$MOD_RESPONSE" | jq -r '[.releases[].version] | last')

    if [[ (($MOD_REMOTE_VERSION_LATEST > $LOCAL_VERSION)) ]]; then
        echo "Updating $NAME from ($LOCAL_VERSION -> $MOD_REMOTE_VERSION_LATEST)"
        NEW_MOD_FILE="${NAME}_${MOD_REMOTE_VERSION_LATEST}.zip"
        #curl -s -L -o $NEW_MOD_FILE https://mods.factorio.com/api/mods/download/${NAME}/${MOD_REMOTE_VERSION_LATEST}?username=${USERNAME}&token=${TOKEN}
    fi
done
