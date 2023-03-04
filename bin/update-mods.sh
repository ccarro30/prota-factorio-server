#!/bin/bash

# Required inputs
MOD_DIRECTORY="/opt/factorio/mods"
USERNAME=$1
TOKEN=$2

if [[ -z $USERNAME || -z $TOKEN ]]; then
    echo 'Usage: update-mods.sh $USERNAME $TOKEN'
    exit 1
fi

# Compile a list of all mods
echo "Checking for mod updates..."
MODS=( $(find $MOD_DIRECTORY -regex '.+[0-9]+\.[0-9]+\.[0-9]+\.zip$' -exec basename {} \; | sed 's/ /%20/g') )

# Loop through every mod in the mod directory
for MOD in ${MODS[@]}
do
    # Parse local mod
    NAME_HTTP=$(echo $MOD | awk -F_ '{NF--; print}')
    NAME_FRIENDLY=$(echo $NAME_HTTP | sed 's/%20/ /g')
    LOCAL_VERSION=$(echo $MOD | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

    # Parse remote mod
    MOD_LATEST_RESPONSE=$(wget -q -O - "https://mods.factorio.com/api/mods/$NAME_HTTP" | jq -r '[.releases[]] | last')
    MOD_REMOTE_FAC_VERSION=$(echo "$MOD_LATEST_RESPONSE" | jq -r '.info_json.factorio_version')
    MOD_REMOTE_VERSION_LATEST=$(echo "$MOD_LATEST_RESPONSE" | jq -r '.version')

    # Compare if remote mod is more recent than local
    if [[ (($MOD_REMOTE_VERSION_LATEST > $LOCAL_VERSION)) ]]; then
        echo "Updating $NAME_FRIENDLY from ($LOCAL_VERSION -> $MOD_REMOTE_VERSION_LATEST)..."
        OLD_MOD_FILE="${NAME_FRIENDLY}_${LOCAL_VERSION}.zip"
        NEW_MOD_FILE="${NAME_FRIENDLY}_${MOD_REMOTE_VERSION_LATEST}.zip"
        MOD_REMOTE_URL_LATEST=$(echo "$MOD_LATEST_RESPONSE" | jq -r '.download_url')
        MOD_REMOTE_SHA1_LATEST=$(echo "$MOD_LATEST_RESPONSE" | jq -r '.sha1')
        HTTP_CODE=$(wget -q -S -c "https://mods.factorio.com${MOD_REMOTE_URL_LATEST}?username=${USERNAME}&token=${TOKEN}" -O "$MOD_DIRECTORY/$NEW_MOD_FILE" 2>&1 | grep "HTTP" | tail -n 1)
        MOD_LOCAL_SHA1_LATEST=$(sha1sum "$MOD_DIRECTORY/$NEW_MOD_FILE" | awk '{print $1}')

        # Simple error checking for downloading
        if [[ "$HTTP_CODE" != *"200"* ]]; then
            rm -f "$MOD_DIRECTORY/$NEW_MOD_FILE"
            echo "Error: $NEW_MOD_FILE could not be downloaded. Remote host returned non-successful HTTP code."
        elif [[ $MOD_REMOTE_SHA1_LATEST != $MOD_LOCAL_SHA1_LATEST ]]; then
            rm -f "$MOD_DIRECTORY/$NEW_MOD_FILE"
            echo "Error: $NEW_MOD_FILE SHA1 does not match remote host. Download incomplete of tampered with."
        else
            rm -f "$MOD_DIRECTORY/$OLD_MOD_FILE"
            echo "Update complete for $NAME_FRIENDLY!"
        fi
    fi
done

echo "Mod updating completed!"
