#!/bin/bash

echo "Setting env for platform...."

export TYK_AUTH=$(paapi secrets access tyk-auth-plat -a platforms -e production | sed 1d)
export TYK_ORG=$(paapi secrets access tyk-org-plat -a platforms -e production | sed 1d)
export API_SECRET=$(paapi secrets access tyk-api-secret-plat -a platform -e production | sed 1d)

echo "Platform env set!!"