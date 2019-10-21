You can run this project using AWS EKS.

## Requirements

* [AWS CLI 1.16.193+](https://aws.amazon.com/cli/), is a unified tool to manage your AWS services
* [eksctl](https://github.com/weaveworks/eksctl), is a simple CLI tool for creating clusters on EKS - Amazon's new managed Kubernetes service for EC2
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), command-line tool, allows you to run commands against Kubernetes clusters
* S3 Bucket, store cluster configurations files, secrets files and configuration maps

Configure these tool to continue.

## How to run

First, you can running the script `./aws/devops_create.sh capstone us-west-2`. This step can spend between 10-15 minutes.

Second, you need to save the file `~/.kube/config` for your S3 Bucket.

Finally, you need to configure a service account for your pods, running the script `./devops_service_account.sh capstone`.

### How to configure Docker registry

If you want to use a private Docker registry, you can execute below steps after third step.

First, you need to create a secret to Docker registry, run this command:

```
kubectl create secret docker-registry capstone-docker-registry-secret \
    --docker-username=DOCKER-USERNAME \
    --docker-password=DOCKER-PASSWORD \
    --docker-email=DOCKER-EMAIL \
    --dry-run=true \
    -o yaml | .secrets/capstone-docker-registry-secret.yaml
```

Second, you need to save the file `.secrets/capstone-docker-registry-secret.yaml` for your S3 Bucket.

Finally, you can running the script `./devops_docker_registry.sh capstone`.
