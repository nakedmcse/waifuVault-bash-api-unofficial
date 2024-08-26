#!/usr/bin/env bash
# Waifuvault BASH SDK Test program
source ./waifuvault-api.sh

# Get Restrictions
echo "-- Get Restrictions --"
waifuvault_get_restrictions
echo $waifuvault_max_file_size
echo $waifuvault_banned_file_types
echo
sleep 1

# Clear Restrictions
echo "-- Clear Restrictions --"
waifuvault_clear_restrictions
echo $waifuvault_max_file_size
echo $waifuvault_banned_file_types
echo
sleep 1

# Upload normal file
echo "-- Upload Normal File --"
waifuvault_upload "/Users/walker/Downloads/rory2.jpg" "5m" "" "false" "false" ""
echo $waifuvault_response
echo $waifuvault_token
echo
sleep 1

# Upload banned file
echo "-- Upload Banned File --"
waifuvault_upload "/Users/walker/Dropbox/Public/filebundler.exe" "5m" "" "false" "false" ""
echo $waifuvault_response
echo $waifuvault_token
echo