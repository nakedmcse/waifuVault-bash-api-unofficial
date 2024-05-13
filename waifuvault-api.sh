#!/usr/bin/env bash
# Waifuvault BASH SDK
waifuvault_baseurl="https://waifuvault.moe/rest"
waifuvault_response=""
waifuvault_token=""

# Upload
waifuvault_upload() {
  local target=$1
  local expires=$2
  local password=$3
  local hideFilename=$4
  local oneTimeDownload=$5

  if [[ "$target" == \~* ]]; then
      target="$HOME/${target:2}"
  fi

  local params="expires=$expires&hide_filename=$hideFilename&one_time_download=$oneTimeDownload"

  if [[ $target == https:* || $target == http:* ]]; then
    waifuvault_response=`curl -sS -X 'PUT' \
        "$waifuvault_baseurl?$params" \
        -H 'accept: application/json' \
        -H 'Content-Type: multipart/form-data' \
        -F "url=$target" \
        -F "password=$password"`
  else
    waifuvault_response=`curl -sS -X 'PUT' \
        "$waifuvault_baseurl?$params" \
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
