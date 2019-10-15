#!/bin/bash

SECRET_NAME="$1"
SECRET_ID="$2"

SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id "$SECRET_ID" --query SecretString --output json)

PRIVATE_DOCKER_USERNAME=$(echo $SECRET_VALUE | jq -r '. fromjson | .PRIVATE_DOCKER_USERNAME')
PRIVATE_DOCKER_PASSWORD=$(echo $SECRET_VALUE | jq -r '. fromjson | .PRIVATE_DOCKER_PASSWORD')
PRIVATE_DOCKER_EMAIL=$(echo $SECRET_VALUE | jq -r '. fromjson | .PRIVATE_DOCKER_EMAIL')

kubectl create secret docker-registry "$SECRET_NAME-private-registry" "--docker-username=$PRIVATE_DOCKER_USERNAME" "--docker-password=$PRIVATE_DOCKER_PASSWORD" "--docker-email=$PRIVATE_DOCKER_EMAIL"
