#!/bin/bash
set -e
set +x

test -f $(which jq) || error_exit "jq command not detected in path, please install it"

eval "$(jq -r '@sh "export ARGO_ADMIN_PASSWORD=\(.argo_password) ARGO_HOSTNAME=\(.argo_hostname)"')"

ARGO_AUTH_BEARER_TOKEN=$(curl -k --location --fail --request POST "$ARGO_HOSTNAME/api/v1/session" \
--header 'Content-Type: application/json' \
--data-raw '{
    "username": "admin",
    "password": "'"$ARGO_ADMIN_PASSWORD"'"
}' 2>/dev/null | jq -r '.token')

ARGO_SERVICE_ACCOUNT_TOKEN=$(curl -k --location --fail --request POST "$ARGO_HOSTNAME/api/v1/account/kerberus-dashboard/token" \
--header "Authorization: Bearer $ARGO_AUTH_BEARER_TOKEN" 2>/dev/null | jq -r '.token')

jq -n --arg ARGO_SERVICE_ACCOUNT_TOKEN "$ARGO_SERVICE_ACCOUNT_TOKEN" '{"argo_token":$ARGO_SERVICE_ACCOUNT_TOKEN}'
