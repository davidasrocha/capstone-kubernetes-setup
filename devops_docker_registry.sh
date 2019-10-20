#!/bin/bash

if [ -z $WORKSPACE ]
then
    WORKSPACE="$PWD"
fi

if [ -n "$1" ] && [ "$1" != "" ]
then
    CLUSTER_NAME="$1"
fi

kubectl apply -f "$WORKSPACE/.secrets/$CLUSTER_NAME-docker-registry-secret.yaml"