# waifuVault-bash-api-unofficial

[![GitHub issues](https://img.shields.io/github/issues/nakedmcse/waifuvault-bash-api-unofficial.png)](https://github.com/nakedmcse/waifuvault-fortran-api-unofficial/issues)
[![last-commit](https://img.shields.io/github/last-commit/nakedmcse/waifuvault-bash-api-unofficial)](https://github.com/nakedmcse/waifuvault-fortran-api-unofficial/commits/master)

This contains the unofficial API bindings for uploading, deleting and obtaining files
with [waifuvault.moe](https://waifuvault.moe/). Contains a full up to date API for interacting with the service.

This is unofficial and as such will not be supported officially.  Use it at your own risk.  Updates to keep it comparable to the official
SDKs will be on a best effort basis only.

## Installation

The SDK uses curl and jq.  You must first install those packages using your package manager.

After that you can copy `waifuvault-api.sh` to `/usr/local/bin`.

You can then reference the waifuvault module at the top of your code.

```bash
source /usr/local/bin/waifuvault-api.sh
```

## Usage

This API contains 5 interactions:

1. [Upload File](#upload-file)
2. [Get File Info](#get-file-info)
3. [Update File Info](#update-file-info)
4. [Delete File](#delete-file)
5. [Get File](#get-file)

You need to include the module files in your code for the package:

```bash
source /usr/local/bin/waifuvault-api.sh
```

### Upload File<a id="upload-file"></a>

To Upload a file, use the `uploadFile` function. This function takes the following options as an object:

| Option            | Type      | Description                                                     | Required | Extra info                       |
|-------------------|-----------|-----------------------------------------------------------------|----------|----------------------------------|
| `target`          | `string ` | The path to the file to upload or its URL                       | true     | File path                        |
| `expires`         | `string`  | A string containing a number and a unit (1d = 1day)             | false    | Valid units are `m`, `h` and `d` |
| `password`        | `string`  | If set, then the uploaded file will be encrypted                | false    |                                  |
| `hideFilename`    | `bool`    | If true, then the uploaded filename won't appear in the URL     | false    | Defaults to `false`              |
| `oneTimeDownload` | `bool`    | if supplied, the file will be deleted as soon as it is accessed | false    |                                  |

Using a URL:

```bash
source /usr/local/bin/waifuvault-api.sh

# Upload URL
echo "-- Upload URL --"
waifuvault_upload "https://waifuvault.moe/assets/custom/images/08.png" "5m" "" "false" "false"
echo $waifuvault_response
echo $waifuvault_token
```

Using a file path:

```bash
source /usr/local/bin/waifuvault-api.sh

# Upload File
echo "-- Upload File --"
waifuvault_upload "~/Downloads/rider2.png" "5m" "" "false" "false"
echo $waifuvault_response
echo $waifuvault_token
```

### Get File Info<a id="get-file-info"></a>

If you have a token from your upload. Then you can get file info. This results in the following info:

* token
* url
* protected
* retentionPeriod

Use the `fileInfo` function. This function takes the following options as parameters:

| Option      | Type      | Description                                                        | Required | Extra info        |
|-------------|-----------|--------------------------------------------------------------------|----------|-------------------|
| `token`     | `string`  | The token of the upload                                            | true     |                   |
| `formatted` | `logical` | If you want the `retentionPeriod` to be human-readable or an epoch | false    | defaults to false |

Epoch timestamp:

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- File Info --"
waifuvault_info $waifuvault_token "false"
echo $waifuvault_response
```

Human-readable timestamp:

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- File Info --"
waifuvault_info $waifuvault_token "true"
echo $waifuvault_response
```

### Update File Info<a id="update-file-info"></a>

If you have a token from your upload, then you can update the information for the file.  You can change the password or remove it,
you can set custom expiry time or remove it, and finally you can choose whether the filename is hidden.

Use the `fileUpdate` function. This function takes the following options as parameters:

| Option              | Type      | Description                                             | Required | Extra info                                  |
|---------------------|-----------|---------------------------------------------------------|----------|---------------------------------------------|
| `token`             | `string`  | The token of the upload                                 | true     |                                             |
| `password`          | `string`  | The current password of the file                        | false    | Set to empty string to remove password      |
| `previousPassword`  | `string`  | The previous password of the file, if changing password | false    |                                             |
| `customExpiry`      | `string`  | Custom expiry in the same form as upload command        | false    | Set to empty string to remove custom expiry |
| `hideFilename`      | `logical` | Sets whether the filename is visible in the URL or not  | false    |                                             |

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- File Update --"
waifuvault_update $waifuvault_token "dangerWaifu" "" "10m" "false"
echo $waifuvault_response
echo
```

### Delete File<a id="delete-file"></a>

To delete a file, you must supply your token to the `deletefile` function.

This function takes the following options as parameters:

| Option  | Type     | Description                              | Required | Extra info |
|---------|----------|------------------------------------------|----------|------------|
| `token` | `string` | The token of the file you wish to delete | true     |            |

Standard delete:

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- File Delete --"
waifuvault_delete $waifuvault_token
echo $waifuvault_response
```

### Get File<a id="get-file"></a>

This lib also supports obtaining a file from the API as a Buffer by supplying either the token or the unique identifier
of the file (epoch/filename).

Use the `getFile` function. This function takes the following options an object:

| Option        | Type     | Description                                       | Required                  | Extra info                                 |
|---------------|----------|---------------------------------------------------|---------------------------|--------------------------------------------|
| `target`      | `string` | The token or URL of the file you want to download | true                      |                                            |
| `destination` | `string` | Filename (full path) for destination              | true                      | Passed as a parameter on the function call |
| `password`    | `string` | The password for the file                         | true if file is encrypted | Passed as a parameter on the function call |

> **Important!** The Unique identifier filename is the epoch/filename only if the file uploaded did not have a hidden
> filename, if it did, then it's just the epoch.
> For example: `1710111505084/08.png` is the Unique identifier for a standard upload of a file called `08.png`, if this
> was uploaded with hidden filename, then it would be `1710111505084.png`

Obtain an encrypted file

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- File Download --"
waifuvault_download $waifuvault_token "~/Downloads/rider2-copy.png" "dangerWaifu"
```