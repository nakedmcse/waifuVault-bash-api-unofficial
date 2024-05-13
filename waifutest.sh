#!/usr/bin/env bash
# Waifuvault BASH SDK Test program
source ./waifuvault-api.sh

# Upload File
echo "-- Upload File --"
waifuvault_upload "~/Downloads/rider2.png" "5m" "dangerWaifu" "false" "false"
echo $waifuvault_response
echo $waifuvault_token
echo
sleep 1

echo "-- File Info --"
waifuvault_info $waifuvault_token "true"
echo $waifuvault_response
echo
sleep 1

echo "-- File Update --"
waifuvault_update $waifuvault_token "dangerWaifu2" "dangerWaifu" "10m" "false"
echo $waifuvault_response
echo
sleep 1

echo "-- File Download --"
waifuvault_download $waifuvault_token "~/Downloads/rider2-copy.png" "dangerWaifu2"
diff ~/Downloads/rider2-copy.png ~/Downloads/rider2.png
echo
sleep 1

echo "-- File Delete --"
waifuvault_delete $waifuvault_token
echo $waifuvault_response
echo
sleep 1

# Upload URL
echo "-- Upload URL --"
waifuvault_upload "https://waifuvault.moe/assets/custom/images/08.png" "5m" "" "false" "false"
echo $waifuvault_response
echo $waifuvault_token
echo
sleep 1

echo "-- File Info --"
waifuvault_info $waifuvault_token "true"
echo $waifuvault_response
echo
sleep 1

echo "-- File Delete --"
waifuvault_delete $waifuvault_token
echo $waifuvault_response
echo
