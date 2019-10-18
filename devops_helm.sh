#!/bin/bash

if [ -z $WORKSPACE ]
then
    WORKSPACE="$PWD"
fi

echo $WORKSPACE

SERVICEACCOUNT=$(kubectl get serviceaccount tiller --namespace=kube-system -o jsonpath='{.metadata.uid}')
if [ "$SERVICEACCOUNT" = '' ]
then
    kubectl apply -f "$WORKSPACE/kubernetes/rbac-config.yaml"
fi

helm init --upgrade --service-account tiller --history-max 100
