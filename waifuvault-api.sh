#!/usr/bin/env bash
# Waifuvault BASH SDK
waifuvault_baseurl="https://waifuvault.moe/rest"
waifuvault_response=""
waifuvault_token=""
waifuvault_bucket_token=""
waifuvault_bucket_files=""
waifuvault_max_file_size=""
waifuvault_banned_file_types=""

# Set Alternate Base URL
waifuvault_set_alt_baseurl() {
  waifuvault_baseurl=$1
}

# Get Restrictions
waifuvault_get_restrictions() {
  waifuvault_response=`curl -sS -X 'GET' "$waifuvault_baseurl/resources/restrictions" -H 'accept: application/json'`
  waifuvault_max_file_size=`echo $waifuvault_response | jq -r '.[] | select(.type == "MAX_FILE_SIZE") | .value'`
  waifuvault_banned_file_types=`echo $waifuvault_response | jq -r '.[] | select(.type == "BANNED_MIME_TYPE") | .value'`
}

# Clear Restrictions
waifuvault_clear_restrictions() {
  waifuvault_banned_file_types=""
  waifuvault_max_file_size=""
}

# Check Restrictions
waifuvault_check_restrictions() {
  local target=$1
  upload_size=`du "$target" | cut -f1`
  upload_mime=`file --mime-type -b "$target"`
  if [ "$upload_size" -gt "$waifuvault_max_file_size" ]; then
      echo "File is larger than the maximum allowed size $waifuvault_max_file_size"
      exit 1
  fi
  if [[ "${waifuvault_banned_file_types}" =~ "${upload_mime}" ]]; then
      echo "The file has a banned MIME type: $upload_mime"
      exit 1
  fi
}

# Create Bucket
waifuvault_create_bucket() {
  waifuvault_response=`curl -sS -X 'GET' "$waifuvault_baseurl/bucket/create" -H 'accept: application/json'`
  waifuvault_bucket_token=`echo $waifuvault_response | jq -r '.token'`
}

# Delete Bucket
waifuvault_delete_bucket() {
  local token=$1
  waifuvault_response=`curl -sS -X 'DELETE' "$waifuvault_baseurl/bucket/$token" -H 'accept: */*'`
}

# Get Bucket
waifuvault_get_bucket() {
  local token=$1
  waifuvault_response=`curl -sS -X 'POST' "$waifuvault_baseurl/bucket/get" -H 'accept: application/json' \
    -H 'Content-Type: application/json' -d "{\"bucket_token\": \"$token\"}"`
  waifuvault_bucket_token=`echo $waifuvault_response | jq -r '.token'`
  waifuvault_bucket_files=`echo $waifuvault_response | jq -r '.files'`
}

# Upload
waifuvault_upload() {
  local target=$1
  local expires=$2
  local password=$3
  local hideFilename=$4
  local oneTimeDownload=$5
  local bucket_token=$6

  local waifuvault_targeturl=$waifuvault_baseurl

  if [[ -n "$bucket_token" ]]; then
      waifuvault_targeturl="$waifuvault_baseurl/$bucket_token"
  fi

  if [[ "$target" == \~* ]]; then
      target="$HOME/${target:2}"
  fi

  local params="expires=$expires&hide_filename=$hideFilename&one_time_download=$oneTimeDownload"

  if [[ $target == https:* || $target == http:* ]]; then
    waifuvault_response=`curl -sS -X 'PUT' \
        "$waifuvault_targeturl?$params" \
        -H 'accept: application/json' \
        -H 'Content-Type: multipart/form-data' \
        -F "url=$target" \
        -F "password=$password"`
  else
    waifuvault_get_restrictions
    waifuvault_check_restrictions $target
    waifuvault_response=`curl -sS -X 'PUT' \
        "$waifuvault_targeturl?$params" \
        -H 'accept: application/json' \
        -H 'Content-Type: multipart/form-data' \
        -F "file=@$target" \
        -F "password=$password"`
  fi
  waifuvault_token=`echo $waifuvault_response | jq -r '.token'`
}

# Download
waifuvault_download() {
  local target=$1
  local dest_path=$2
  local password=$3

  if [[ $target != https:* && $target != http:* ]]; then
    waifuvault_info $target "false"
    target=`echo $waifuvault_response | jq -r '.url'`
  fi

  if [[ "$dest_path" == \~* ]]; then
        dest_path="$HOME/${dest_path:2}"
  fi

  if [[ $password ]]; then
    curl -X 'GET' $target -H "x-password: $password" -o $dest_path
  else
    curl -X 'GET' $target -o $dest_path
  fi
}

# Info
waifuvault_info() {
  local token=$1
  local formatted=$2
  waifuvault_response=`curl -sS -X 'GET' "$waifuvault_baseurl/$token?formatted=$formatted" -H 'accept: application/json'`
}

# Update
waifuvault_update() {
  local token=$1
  local password=$2
  local previous_password=$3
  local expires=$4
  local hide_filename=$5
  waifuvault_response=`curl -sS -X 'PATCH' \
                         "$waifuvault_baseurl/$token" \
                         -H 'accept: application/json' \
                         -H 'Content-Type: application/json' \
                         -d "{
                         \"password\": \"$password\",
                         \"previousPassword\": \"$previous_password\",
                         \"customExpiry\": \"$expires\",
                         \"hideFilename\": $hide_filename
                       }"`
}

# Delete
waifuvault_delete() {
  local token=$1
  waifuvault_response=`curl -sS -X 'DELETE' "$waifuvault_baseurl/$token" -H 'accept: */*'`
}
