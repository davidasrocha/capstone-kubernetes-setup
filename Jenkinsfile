pipeline {
    agent any

    parameters {
        choice(name: 'OPERATION', choices: ['none', 'create', 'delete', 'update'], description: 'Choose an operation to Kubernetes Cluster')
    }

    environment {
        CLUSTER_NAME = "capstone"
        BUCKET_NAME = "capstone-cicd-storage-eks-configs"
        REGION = "us-west-2"
    }

    stages {
        stage('Operations to Cluster') {
            when {
                allOf {
                    expression { params.OPERATION == 'create' || params.OPERATION == 'delete' }
                }
            }
            steps {
                withAWS(region: "$REGION", credentials: 'AWS_DEVOPS') {
                    sh "./${params.OPERATION}.sh $CLUSTER_NAME $REGION"
                }
            }
        }
        stage('Save configuration') {
            when {
                expression { params.OPERATION == 'create' }
            }
            steps {
                withAWS(region: "$REGION", credentials: 'AWS_DEVOPS') {
                    s3Upload(file: "$WORKSPACE/.kube/config", bucket: "$BUCKET_NAME", path: "$CLUSTER_NAME")
                }
            }
        }
        stage('Configure Docker Registry Secret') {
            when {
                allOf {
                    expression { params.OPERATION == 'create' }
                }
            }
            environment {
                KUBECONFIG = "$WORKSPACE/.kube/config"
            }
            steps {
                withAWS(region: "$REGION", credentials: 'AWS_DEVOPS') {
                    s3Download(file: "$KUBECONFIG", bucket: "$BUCKET_NAME", path: "$CLUSTER_NAME", force: true)
                    s3Download(file: "$WORKSPACE/.secrets/$CLUSTER_NAME-docker-registry-secret.yaml", bucket: "$BUCKET_NAME", path: "$CLUSTER_NAME-docker-registry-secret.yaml", force: true)
                    sh "kubectl apply -f $WORKSPACE/.secrets/$CLUSTER_NAME-docker-registry-secret.yaml"
                }
            }
        }
        stage('Configure Service Account') {
            when {
                allOf {
                    expression { params.OPERATION == 'create' || params.OPERATION == 'update' }
                }
            }
            environment {
                KUBECONFIG = "$WORKSPACE/.kube/config"
            }
            steps {
                withAWS(region: "$REGION", credentials: 'AWS_DEVOPS') {
                    s3Download(file: "$KUBECONFIG", bucket: "$BUCKET_NAME", path: "$CLUSTER_NAME", force: true)
                    sh "kubectl patch serviceaccount default -p '{\"imagePullSecrets\": [{\"name\":\"$CLUSTER_NAME-docker-registry-secret\"}]}'"
                }
            }
        }
        stage('Initialize Helm and Install Tiller') {
            when {
                allOf {
                    expression { params.OPERATION == 'create' || params.OPERATION == 'update' }
                }
            }
            environment {
                KUBECONFIG = "$WORKSPACE/.kube/config"
            }
            steps {
                withAWS(region: "$REGION", credentials: 'AWS_DEVOPS') {
                    s3Download(file: "$KUBECONFIG", bucket: "$BUCKET_NAME", path: "$CLUSTER_NAME", force: true)
                    sh "./devops_helm.sh"
                }
            }
        }
    }
}