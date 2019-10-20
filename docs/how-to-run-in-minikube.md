You can run this project using Minikube.

## Requirements

* [AWS CLI 1.16.193+](https://aws.amazon.com/cli/), is a unified tool to manage your AWS services
* [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/), minikube implements a local Kubernetes cluster on macOS, Linux, and Windows
* [Helm](https://helm.sh/), package manager to Kubernetes
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), command-line tool, allows you to run commands against Kubernetes clusters

Configure these tool to continue.

## How to run

First, you need to run below command to start cluster:

```
minikube start
```

Second, this is a optional step only if you want to use a private Docker registry, run this command:

```
kubectl create secret docker-registry capstone-docker-registry-secret \
    --docker-username=DOCKER-USERNAME \
    --docker-password=DOCKER-PASSWORD \
    --docker-email=DOCKER-EMAIL
```

Third, you need to configure a service account for your pods, running the script `./devops_service_account.sh capstone`.

Finally, you need to configure the Helm, running the script `./devops_helm.sh`.
