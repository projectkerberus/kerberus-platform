#!/bin/bash
set -e
set +x

test -f $(which jq) || error_exit "jq command not detected in path, please install it"

eval "$(jq -r '@sh "export ARGO_ADMIN_PASSWORD=\(.argo_password) ARGO_HOSTNAME=\(.argo_hostname)"')"

ARGO_REPONSE=$(curl -k --fail --location --request POST "$ARGO_HOSTNAME/api/v1/session" \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "admin",
    "password": "'"$ARGO_ADMIN_PASSWORD"'"
}') || \
(echo "Fail to retreive bearer token. Please check if $ARGO_HOSTNAME is a valid endpoint" >&2; exit 1)

ARGO_AUTH_BEARER_TOKEN=$(echo $ARGO_REPONSE | jq -r '.token')

ARGO_REPONSE=$(curl -k --fail --location --request POST "$ARGO_HOSTNAME/api/v1/account/kerberus-dashboard/token" \
--header "Authorization: Bearer $ARGO_AUTH_BEARER_TOKEN") || \
(echo "Fail to retreive kerberus-dashboard service token. Please check if kerberus-dashboard service account is present on ArgoCD" >&2; exit 1)

ARGO_SERVICE_ACCOUNT_TOKEN=$(echo $ARGO_REPONSE | jq -r '.token')

jq -n --arg ARGO_SERVICE_ACCOUNT_TOKEN "$ARGO_SERVICE_ACCOUNT_TOKEN" --arg ID "$RANDOM" '{"id": $ID, "argo_token":$ARGO_SERVICE_ACCOUNT_TOKEN}'
