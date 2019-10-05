#!/bin/bash

if [ -z $1 ] || [ $1 = "" ]
then
    echo "Cluster name wasn't provided"
    exit 255
fi

CLUSTER_NAME="$1"

eksctl delete cluster \
    --name "$CLUSTER_NAME"

echo ""
echo "Waiting stack eksctl-$CLUSTER_NAME-cluster delete"
echo ""

aws cloudformation wait stack-delete-complete \
    --stack-name "eksctl-$CLUSTER_NAME-cluster"
