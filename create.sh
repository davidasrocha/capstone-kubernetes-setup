#!/bin/bash

if [ -z $1 ] || [ $1 = "" ]
then
    echo "Cluster name wasn't provided"
    exit 255
fi

if [ -z $2 ] || [ $2 = "" ]
then
    echo "Region wasn't provided"
    exit 255
fi

if [ $2 = "none" ]
then
    echo "Region none is invalid. Please choose another region"
    exit 255
fi

CLUSTER_NAME="$1"
REGION="$2"

eksctl create cluster \
    --name "$CLUSTER_NAME" \
    --version "1.11" \
    --nodegroup-name "workers" \
    --node-type "t3.medium" \
    --region "$REGION" \
    --nodes 3 \
    --nodes-min 1 \
    --nodes-max 4
