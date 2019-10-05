#!/bin/bash

if [ -z $1 ] || [ $1 = "" ]
then
    echo "Cluster name wasn't provided"
    exit 255
fi

CLUSTER_NAME="$1"

eksctl delete cluster \
    --name "$CLUSTER_NAME"
