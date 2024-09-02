#!/usr/bin/env bash
# Waifuvault BASH SDK Test program
source ./waifuvault-api.sh

# Set Alternate Base URL
echo "-- Set Alt Base URL--"
waifuvault_set_alt_baseurl "https://waifuvault.walker.moe/rest"

# Create a bucket
echo "-- Create Bucket --"
waifuvault_create_bucket
echo $waifuvault_bucket_token
echo
sleep 1

# Upload files to bucket
echo "-- Upload File --"
waifuvault_upload "/Users/walker/Downloads/rory2.jpg" "5m" "" "false" "false" "$waifuvault_bucket_token"
echo $waifuvault_response
echo $waifuvault_token
echo
sleep 1

echo "-- Upload File --"
waifuvault_upload "/Users/walker/Downloads/vic_laptop.jpg" "5m" "" "false" "false" "$waifuvault_bucket_token"
echo $waifuvault_response
echo $waifuvault_token
echo
sleep 1

# Get bucket contents
echo "-- Get Bucket --"
waifuvault_get_bucket "$waifuvault_bucket_token"
echo $waifuvault_bucket_token
echo $waifuvault_bucket_files
echo
sleep 1

# Delete bucket
echo "-- Delete Bucket --"
waifuvault_delete_bucket "$waifuvault_bucket_token"
echo $waifuvault_response
echo
sleep 1
