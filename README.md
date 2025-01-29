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

This API contains 20 interactions:

1. [Upload File](#upload-file)
2. [Get File Info](#get-file-info)
3. [Update File Info](#update-file-info)
4. [Delete File](#delete-file)
5. [Get File](#get-file)
6. [Create Bucket](#create-bucket)
7. [Delete Bucket](#delete-bucket)
8. [Get Bucket](#get-bucket)
9. [Create Album](#create-album)
10. [Delete Album](#delete-album)
11. [Get Album](#get-album)
12. [Associate File](#associate-file)
13. [Disassociate File](#disassociate-file)
14. [Share Album](#share-album)
15. [Revoke Album](#revoke-album)
16. [Download Album](#download-album)
17. [Get Restrictions](#get-restrictions)
18. [Clear Restrictions](#clear-restrictions)
19. [Get File Stas](#get-file-stats)
20. [Set Alternate Base URL](#set-alt-baseurl)

You need to include the module files in your code for the package:

```bash
source /usr/local/bin/waifuvault-api.sh
```

### Upload File<a id="upload-file"></a>

To Upload a file, use the `waifuvault_upload` function. This function takes the following options as an object:

| Option            | Type      | Description                                                     | Required | Extra info                       |
|-------------------|-----------|-----------------------------------------------------------------|----------|----------------------------------|
| `target`          | `string ` | The path to the file to upload or its URL                       | true     | File path                        |
| `expires`         | `string`  | A string containing a number and a unit (1d = 1day)             | false    | Valid units are `m`, `h` and `d` |
| `password`        | `string`  | If set, then the uploaded file will be encrypted                | false    |                                  |
| `hideFilename`    | `bool`    | If true, then the uploaded filename won't appear in the URL     | false    | Defaults to `false`              |
| `oneTimeDownload` | `bool`    | if supplied, the file will be deleted as soon as it is accessed | false    |                                  |
| `bucketToken`     | `string`  | Bucket token for token to contain file                          | false    |                                  |

> **NOTE:** Server restrictions are checked by the SDK client side *before* upload, and will exit if they are violated

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

Use the `waifuvault_info` function. This function takes the following options as parameters:

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

Use the `waifuvault_update` function. This function takes the following options as parameters:

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

To delete a file, you must supply your token to the `waifuvault_delete` function.

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

Use the `waifuvault_donwload` function. This function takes the following options an object:

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

### Create Bucket<a id="create-bucket"></a>

Buckets are virtual collections that are linked to your IP and a token. When you create a bucket, you will receive a bucket token that you can use in Get Bucket to get all the files in that bucket

> **NOTE:** Only one bucket is allowed per client IP address, if you call it more than once, it will return the same bucket token

To create a bucket, use the `waifuvault_create_bucket` function. This function does not take any arguments.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Create Bucket --"
waifuvault_create_bucket
echo $waifuvault_bucket_token
```

### Delete Bucket<a id="delete-bucket"></a>

Deleting a bucket will delete the bucket and all the files it contains.

> **IMPORTANT:**  All contained files will be **DELETED** along with the Bucket!

To delete a bucket, you must call the `waifuvault_delete_bucket` function with the following options as parameters:

| Option      | Type      | Description                       | Required | Extra info        |
|-------------|-----------|-----------------------------------|----------|-------------------|
| `token`     | `string`  | The token of the bucket to delete | true     |                   |

> **NOTE:** `deleteBucket` will only ever either return `true` or throw an exception if the token is invalid

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Delete Bucket --"
waifuvault_delete_bucket "$waifuvault_bucket_token"
echo $waifuvault_response
```

### Get Bucket<a id="get-bucket"></a>

To get the list of files contained in a bucket, you use the `waifuvault_get_bucket` functions and supply the token.
This function takes the following options as parameters:

| Option      | Type      | Description             | Required | Extra info        |
|-------------|-----------|-------------------------|----------|-------------------|
| `token`     | `string`  | The token of the bucket | true     |                   |

This will respond with the bucket and all the files the bucket contains.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Get Bucket --"
waifuvault_get_bucket "$waifuvault_bucket_token"
echo $waifuvault_bucket_token
echo $waifuvault_bucket_files
```

### Create Album<a id="create-album"></a>
Albums are shareable collections of files that exist within a bucket.

To create an album, you use the `waifuvault_create_album` function and supply a bucket token and name.

The function takes the following parameters:

| Option         | Type      | Description                         | Required | Extra info        |
|----------------|-----------|-------------------------------------|----------|-------------------|
| `bucket_token` | `string`  | The token of the bucket             | true     |                   |
| `name`         | `string`  | The name of the album to be created | true     |                   |

This will respond with an album object containing the name and token of the album.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Create Album --"
waifuvault_create_album $waifuvault_bucket_token "test-album"
echo $waifuvault_album_token
echo $waifuvault_album_name
```

### Delete Album<a id="delete-album"></a>
To delete an album, you use the `waifuvault_delete_album` function and supply the album token and a boolean indication of whether
or not the files contained in the album should be deleted or not.  If you chose false, the files will be returned to the
bucket.

The function takes the following parameters:

| Option         | Type     | Description                         | Required | Extra info        |
|----------------|----------|-------------------------------------|----------|-------------------|
| `album_token`  | `string` | The private token of the album      | true     |                   |
| `delete_files` | `bool`   | Whether the files should be deleted | true     |                   |

> **NOTE:** If `delete_files` is set to True, the files will be permanently deleted

This will respond with a boolean indicating success.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Delete Album --"
waifuvault_delete_album $waifuvault_album_token "false"
echo $waifuvault_response
```

### Get Album<a id="get-album"></a>
To get the contents of an album, you use the `waifuvault_get_album` function and supply the album token.  The token can be either the private token
or the public token.

The function takes the following parameters:

| Option   | Type     | Description            | Required | Extra info                     |
|----------|----------|------------------------|----------|--------------------------------|
| `token`  | `string` | The token of the album | true     | Can be private or public token |

This will respond with the album object containing the album information and files contained within the album.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Get Album --"
waifuvault_get_album $waifuvault_album_token 
echo $waifuvault_album_token
echo $waifuvault_album_public_token
echo $waifuvault_album_name
echo $waifuvault_album_files
```

### Associate File<a id="associate-file"></a>
To add files to an album, you use the `waifuvault_album_associate` function and supply the private album token and
a list of file tokens.

The function takes the following parameters:

| Option  | Type           | Description                         | Required | Extra info |
|---------|----------------|-------------------------------------|----------|------------|
| `token` | `string`       | The private token of the album      | true     |            |
| `files` | `list[string]` | List of file tokens to add to album | true     |            |

This will respond with the new album object containing the added files.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Associate Album --"
waifuvault_album_associate $waifuvault_album_token "\"${file1}\",\"${file2}\""
echo $waifuvault_album_token
echo $waifuvault_album_name
echo $waifuvault_album_files
```

### Disassociate File<a id="disassociate-file"></a>
To remove files from an album, you use the `waifuvault_album_disassociate` function and supply the private album token and
a list of file tokens.

The function takes the following parameters:

| Option  | Type           | Description                         | Required | Extra info |
|---------|----------------|-------------------------------------|----------|------------|
| `token` | `string`       | The private token of the album      | true     |            |
| `files` | `list[string]` | List of file tokens to add to album | true     |            |

This will respond with the new album object with the files removed.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Disassociate Album --"
waifuvault_album_disassociate $waifuvault_album_token "\"${file1}\",\"${file2}\""
echo $waifuvault_album_token
echo $waifuvault_album_name
echo $waifuvault_album_files
```

### Share Album<a id="share-album"></a>
To share an album, so it contents can be accessed from a public URL, you use the `waifuvault_share_album` function and
supply the private token.

The function takes the following parameters:

| Option  | Type           | Description                         | Required | Extra info |
|---------|----------------|-------------------------------------|----------|------------|
| `token` | `string`       | The private token of the album      | true     |            |

This will respond with the public URL with which the album can be found.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Share Album --"
waifuvault_share_album $waifuvault_album_token
echo $waifuvault_album_url
```

> **NOTE:** The public album token can now be found in the `get_album` results

### Revoke Album<a id="revoke-album"></a>
To revoke the sharing of an album, so it will no longer be accessible publicly, you use the `waifuvault_revoke_album` function
and supply the private token.

The function takes the following parameters:

| Option  | Type           | Description                         | Required | Extra info |
|---------|----------------|-------------------------------------|----------|------------|
| `token` | `string`       | The private token of the album      | true     |            |

This will respond with a boolean True if the album was revoked.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Revoke Album --"
waifuvault_revoke_album $waifuvault_album_token
echo $waifuvault_album_url
```

> **NOTE:** Once revoked, the URL for sharing is destroyed.  If the album is later shared again, the URL issued will be different.


### Get Restrictions<a id="get-restrictions"></a>

To get the list of restrictions applied to the server, you use the `waifuvault_get_restrictions` functions.

This will respond with values describing the restrictions applied to the server.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Get Restrictions --"
waifuvault_get_restrictions
echo $waifuvault_max_file_size
echo $waifuvault_banned_file_types
```

### Clear Restrictions<a id="clear-restrictions"></a>

To clear the downloaded restrictions in the SDK, you use the `waifuvault_clear_restrictions` function.

This will remove the restrictions and a fresh copy will be downloaded at the next upload.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Clear Restrictions --"
waifuvault_clear_restrictions
echo $waifuvault_max_file_size
echo $waifuvault_banned_file_types
```

### Get File Stats<a id="get-file-stats"></a>

To get general file stats for the server, you use the `waifuvault_get_file_stats` function.

This takes no parameters and returns the number of files and the size of files on the server.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Get File Stats --"
waifuvault_get_file_stats
echo $waifuvault_records_count
echo $waifuvault_records_size
```

### Set Alternate Base URL<a id="set-alt-baseurl"></a>

To set a custom base URL in the SDK, you use the `waifuvault_set_alt_baseurl` function.

This will change the base URL used for all functions within the SDK.

```bash
source /usr/local/bin/waifuvault-api.sh

echo "-- Set Alt Base URL--"
waifuvault_set_alt_baseurl "https://waifuvault.walker.moe/rest"
```