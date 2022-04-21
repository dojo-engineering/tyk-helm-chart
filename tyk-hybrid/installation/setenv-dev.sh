#!/bin/bash

echo "Setting env for dev...."

export TYK_AUTH=$(paapi secrets access tyk-auth-dev -a platform -e development | sed 1d)
export TYK_ORG=$(paapi secrets access tyk-org-dev -a platform -e development | sed 1d)
export API_SECRET=$(paapi secrets access tyk-api-secret-dev -a platform -e development | sed 1d)

echo "Dev env set!!"