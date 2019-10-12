pipeline {
    agent any

    parameters {
        string(name: 'CLUSTER_NAME', defaultValue: '', description: 'Provide a name to Kubernetes Cluster')

        string(name: 'BUCKET_NAME', defaultValue: '', description: 'Bucket name to store Kubernetes Cluster configuration')

        choice(name: 'OPERATION', choices: ['create', 'delete'], description: 'Choose an operation to Kubernetes Cluster')

        choice(name: 'REGION', choices: ['us-west-1', 'us-west-2'], description: 'Choose an AWS region to deploy the Kubernetes Cluster')

        choice(name: 'PRIVATE_DOCKER_HUB', choices: ['no', 'yes'], description: 'Will use Private Docker Hub Account?')
        string(name: 'PRIVATE_DOCKER_USERNAME', defaultValue: '', description: 'Docker Hub Username')
        string(name: 'PRIVATE_DOCKER_PASSWORD', defaultValue: '', description: 'Docker Hub Password')
        string(name: 'PRIVATE_DOCKER_EMAIL', defaultValue: '', description: 'Docker Hub E-mail')
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
        stage('Configure Docker Hub Registry') {
            when {
                allOf {
                    expression { params.PRIVATE_DOCKER_HUB == 'yes' }
                    expression { params.PRIVATE_DOCKER_USERNAME != '' && params.PRIVATE_DOCKER_PASSWORD != '' && params.PRIVATE_DOCKER_EMAIL != ''}
                }
            }
            steps {
                sh "kubectl create secret docker-registry ${params.PRIVATE_DOCKER_HUB} --docker-username=${params.PRIVATE_DOCKER_USERNAME} --docker-password=${params.PRIVATE_DOCKER_PASSWORD} --docker-email=${params.PRIVATE_DOCKER_EMAIL}"
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