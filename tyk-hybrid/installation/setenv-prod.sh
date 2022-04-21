#!/bin/bash

echo "Setting env for prod...."


export TYK_AUTH=$(paapi secrets access tyk-auth-prod -a platform -e production | sed 1d)
export TYK_ORG=$(paapi secrets access tyk-org-prod -a platform -e production | sed 1d)
export API_SECRET=$(paapi secrets access tyk-api-secret-prod -a platform -e production | sed 1d)

echo "Platform env set!!"