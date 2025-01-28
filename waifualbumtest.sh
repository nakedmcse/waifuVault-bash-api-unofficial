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
file1=$waifuvault_token
sleep 1

echo "-- Upload File --"
waifuvault_upload "/Users/walker/Downloads/GothAlya.jpeg" "5m" "" "false" "false" "$waifuvault_bucket_token"
echo $waifuvault_response
echo $waifuvault_token
echo
file2=$waifuvault_token
sleep 1

# Create Album
echo "-- Create Album --"
waifuvault_create_album $waifuvault_bucket_token "test-album"
echo $waifuvault_album_token
echo $waifuvault_album_name
echo
sleep 1

# Associate Files
echo "-- Associate Album --"
waifuvault_album_associate $waifuvault_album_token "\"${file1}\",\"${file2}\""
echo $waifuvault_album_token
echo $waifuvault_album_name
echo $waifuvault_album_files
echo $waifuvault_response
echo
sleep 1

# Share Album
echo "-- Share Album --"
waifuvault_share_album $waifuvault_album_token
echo $waifuvault_album_url
echo
sleep 1

# Download Album
echo "-- Download Album --"
waifuvault_get_album $waifuvault_album_token
waifuvault_album_download $waifuvault_album_public_token "test-album.zip" ""
echo
ls test-album.zip
rm -f test-album.zip
echo
sleep 1

# Revoke Album
echo "-- Revoke Album --"
waifuvault_album_revoke $waifuvault_album_token
echo $waifuvault_album_url
echo
sleep 1

# Disassociate Files
echo "-- Disassociate Album --"
waifuvault_album_disassociate $waifuvault_album_token "\"${file1}\",\"${file2}\""
echo $waifuvault_album_token
echo $waifuvault_album_name
echo $waifuvault_album_files
echo
sleep 1

# Delete Album
echo "-- Delete Album --"
waifuvault_delete_album $waifuvault_album_token "false"
echo $waifuvault_response
echo
sleep 1

# Delete bucket
echo "-- Delete Bucket --"
waifuvault_delete_bucket "$waifuvault_bucket_token"
echo $waifuvault_response
echo
sleep 1