#!/usr/bin/env bash
set -ex

gcloud auth activate-service-account platform-publisher@firefly-devops-2018.iam.gserviceaccount.com --key-file=${CI_SECRETS_PATH}/plat-publish.json

gcloud container clusters get-credentials platform --project firefly-devops-2018 --zone europe-west2-a

helm upgrade --install tyk-hybrid ./tyk-hybrid -f ./tyk-hybrid/values.yaml --set redis.pass=${TYK_REDIS_KEY} \
--set gateway.hostName=tyk-platform.paymentsense.tech --set gateway.rpc.connString=${TYK_CONN_STRING} \
--set gateway.rpc.rpcKey=${TYK_ORG_ID} --set gateway.rpc.apiKey=${TYK_API_ACCESS_KEY} \
--set gateway.ingress.annotations.kubernetes\.io/ingress\.global-static-ip-name=platform-tyk-nginx -n tyk --wait