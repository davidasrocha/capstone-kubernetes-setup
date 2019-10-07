pipeline {
    agent any

    parameters {
        string(name: 'CLUSTER_NAME', defaultValue: '', description: 'Provide a name to Kubernetes Cluster')

        string(name: 'BUCKET_NAME', defaultValue: '', description: 'Provide a name to bucket to store Kubernetes Cluster configuration')

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
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    sh "helm --kubeconfig $WORKSPACE/.kube/config init --history-max 100"
                }
            }
        }
        stage('Save configuration') {
            when {
                expression { params.OPERATION == 'create' }
                expression { params.CLUSTER_NAME != '' && params.BUCKET_NAME != '' }
            }
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    s3Upload(file: "$WORKSPACE/.kube/config", bucket: "${params.BUCKET_NAME}", path: "${params.CLUSTER_NAME}")
                }
            }
        }
        stage('Remove configuration') {
            when {
                expression { params.OPERATION == 'delete' }
                expression { params.CLUSTER_NAME != '' && params.BUCKET_NAME != '' }
            }
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    s3Delete(bucket: "${params.BUCKET_NAME}", path: "${params.CLUSTER_NAME}")
                }
            }
        }
    }
}