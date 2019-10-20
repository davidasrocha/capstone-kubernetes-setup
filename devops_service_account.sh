#!/bin/bash

if [ -n "$1" ] && [ "$1" != "" ]
then
    CLUSTER_NAME="$1"
fi

kubectl patch serviceaccount default -p "{\"imagePullSecrets\": [{\"name\":\"$CLUSTER_NAME-docker-registry-secret\"}]}"