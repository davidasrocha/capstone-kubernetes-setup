pipeline {
    agent any

    parameters {
        string(name: 'CLUSTER_NAME', defaultValue: '', description: 'Provide a name to Kubernetes Cluster')

        string(name: 'BUCKET_NAME', defaultValue: '', description: 'Provide a name to bucket to store Kubernetes Cluster configuration')

        string(name: 'KUBECONFIG_NAME', defaultValue: '', description: 'Provide a name to Kubernetes Cluster configuration file')

        choice(name: 'OPERATION', choices: ['create', 'delete'], description: 'Choose an operation to Kubernetes Cluster')

        choice(name: 'REGION', choices: ['us-west-1', 'us-west-2', 'none'], description: 'Choose an AWS region to deploy the Kubernetes Cluster')
    }

    stages {
        stage('Operations to Cluster') {
            when {
                allOf {
                    expression { params.CLUSTER_NAME != '' }
                    expression { params.OPERATION == 'create' || params.OPERATION == 'delete' }
                }
            }
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    sh "./${params.OPERATION}.sh ${params.CLUSTER_NAME} ${params.REGION}"
                }
            }
        }
        stage('Initialize Helm and Install Tiller') {
            when {
                allOf {
                    expression { params.CLUSTER_NAME != '' }
                    expression { params.OPERATION == 'create' }
                }
            }
            environment {
                KUBECONFIG = "$PWD/.kube/config"
            }
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    sh "helm init --history-max 200"
                }
            }
        }
        stage('Upload configuration to S3') {
            when {
                expression { params.CLUSTER_NAME != '' && params.BUCKET_NAME != '' && params.KUBECONFIG_NAME != '' }
                expression { params.OPERATION == 'create' }
            }
            environment {
                KUBECONFIG = "$PWD/.kube/config"
            }
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    s3Upload(file: "$KUBECONFIG", bucket: "${params.BUCKET_NAME}", path: "${params.KUBECONFIG_NAME}")
                }
            }
        }
    }
}