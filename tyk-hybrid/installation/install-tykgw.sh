case $1 in
	platform)
		source installation/setenv-platform.sh
		;;
	dev)
		echo "setting env for dev...."
		source installation/setenv-dev.sh
		;;
	stg)
		echo "setting env for staging...."
		source installation/setenv-staging.sh
		;;
	prod)
		echo "Setting env for prod...."
		source installation/setenv-prod.sh
		;;
	*)
		echo "provide env properly i.e. ./install-tykgw.sh value, value can be platform/dev/stg/prod"
		exit 1
		;;
  esac

echo $"\n\n-------------------------------------\nCreating secret for $1"


helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

kubectl create namespace tyk

echo $"\n\n-------------------------------------\nInstalling redis..."

helm install \
tyk-redis bitnami/redis \
--namespace tyk \
--create-namespace \
--wait

export REDIS_PASSWORD=$(kubectl get secret --namespace tyk tyk-redis -o jsonpath="{.data.redis-password}" | base64 --decode)

echo $"\nTYK_AUTH=${TYK_AUTH}"
echo $"\nTYK_ORG=${TYK_ORG}"
echo $"\nTYK_MODE=${API_SECRET}"
echo $"\nTYK_URL=${TYK_URL_MCDB}"
echo $"\nREDIS_PASSWORD=${REDIS_PASSWORD}"


kubectl create secret -n tyk generic tyk-hybrid-gateway-secrets \
  --from-literal "APISecret=${API_SECRET}" \
  --from-literal "apiKey=${TYK_AUTH}" \
  --from-literal "redisPass=${REDIS_PASSWORD}" \
  --from-literal "rpcKey=${TYK_ORG}"

#TBD in separate steps
# Create TLS secret based on your domain *.dojo.dev/ *.dojo.tech/ *.paymentsense.tech

#helm install tyk-hybrid . -f <value yaml> --wait