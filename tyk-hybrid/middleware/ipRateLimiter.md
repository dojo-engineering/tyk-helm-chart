# IP Rate Limiter

***These docs should be moved***

## Setup

### Auth

enable auth on your tyk api  
Auth Mode: *Authentication Token*  
Auth Key Header Name: *X-Tyk-Authorization*  

### Policy

Create a policy with the required access and ratelimiting needed  
make a note of the policy id as you'll need this later.

### Middleware

To add middleware you need to edit the raw apidefinition, this can be done using the `View Raw Definition` button in the top right of the api editor

find the `custom_middleware` key, and in the `pre` middleware list add:

```json
{
  "name": "ipRateLimiter",
  "path": "middleware/ipRateLimiter.js",
  "require_session": false,
  "raw_body_only": false
}
```

so in the end it would look like

```json
"custom_middleware": {
  "pre": [
    {
      "name": "ipRateLimiter",
      "path": "middleware/ipRateLimiter.js",
      "require_session": false,
      "raw_body_only": false
    }
  ],

  ...

}
```

#### Config Data

set config data (Advanced Options -> Config Data) to

```json
{
  "ipRateLimiter": {
    "policies": [
      "<your-tyk-policy id's here>"
    ],
    "versions": [
      "<ApiVersionsThatNeedAccess>"
    ]
  }
}
```

if you do not include a version in the list of versions the key generated will not have access to that version.

## How it works

reads ip address from X-Forwarded-For header  
creates an authentication token using the users IP and the APIID  
for example a user with ip `5.198.12.5` accessing api with ID `123455679abcdefg` would have an auth token/key`5.198.12.5-123455679abcdefg`.  

This key is linked to the policies provided in the `config_data`.

we then use default tyk token authentication to apply ratelimiting.
