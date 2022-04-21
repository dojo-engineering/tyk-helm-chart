#!/bin/bash

echo "Setting env for staging...."

export TYK_AUTH=$(paapi secrets access tyk-auth-stg -a platform -e staging | sed 1d)
export TYK_ORG=$(paapi secrets access tyk-org-stg -a platform -e staging | sed 1d)
export API_SECRET=$(paapi secrets access tyk-api-secret-stg -a platform -e staging | sed 1d)

echo "Staging env set!!"