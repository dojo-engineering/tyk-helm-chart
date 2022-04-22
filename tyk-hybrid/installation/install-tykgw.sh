#!/bin/bash

case $1 in
	platform)
		source installation/setenv-platform.sh
		;;
	dev)
		source installation/setenv-dev.sh
		;;
	stg)
		source installation/setenv-staging.sh
		;;
	prod)
		source installation/setenv-prod.sh
		;;
	*)
		echo "provide env properly i.e. ./install-tykgw.sh value, value can be platform/dev/stg/prod"
		exit 1
		;;
  esac

echo
echo
echo "-------------------------------------"
echo "Updating helm"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

kubectl create namespace tyk

echo
echo
echo "-------------------------------------"
echo "Installing redis..."

helm install \
tyk-redis bitnami/redis \
--set global.storageClass=premium-rwo \
--namespace tyk \
--create-namespace \
--wait

export REDIS_PASSWORD=$(kubectl get secret --namespace tyk tyk-redis -o jsonpath="{.data.redis-password}" | base64 --decode)

echo
echo
echo "-------------------------------------"
echo "Creating secret for $1..."


echo "TYK_AUTH=${TYK_AUTH}"
echo "TYK_ORG=${TYK_ORG}"
echo "API_SECRET=${API_SECRET}"
echo "REDIS_PASSWORD=${REDIS_PASSWORD}"



kubectl create secret -n tyk generic tyk-hybrid-gateway-secrets \
  --from-literal "APISecret=${API_SECRET}" \
  --from-literal "apiKey=${TYK_AUTH}" \
  --from-literal "redisPass=${REDIS_PASSWORD}" \
  --from-literal "rpcKey=${TYK_ORG}"

echo
echo
echo "-------------------------------------"
echo "Adding pod and service monitor CRD..."
kubectl apply -f https://raw.githubusercontent.com/grafana/agent/main/production/operator/crds/monitoring.coreos.com_servicemonitors.yaml
kubectl apply -f https://raw.githubusercontent.com/grafana/agent/main/production/operator/crds/monitoring.coreos.com_podmonitors.yaml
kubectl create namespace grafana-agent
#TBD in separate steps
# Create TLS secret based on your domain *.dojo.dev/ *.dojo.tech/ *.paymentsense.tech

#helm install tyk-hybrid . -f <value yaml> --wait