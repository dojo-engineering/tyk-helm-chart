#!/usr/bin/env bash
set -ex
gcloud auth activate-service-account platform-publisher@firefly-devops-2018.iam.gserviceaccount.com --key-file=${CI_SECRETS_PATH}/plat-publish.json

gcloud container clusters get-credentials platform --project firefly-devops-2018 --zone europe-west2-a

helm upgrade --install tyk-hybrid ./tyk-hybrid -f ./tyk-hybrid/values-platform.yaml