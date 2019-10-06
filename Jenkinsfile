pipeline {
    agent any

    parameters {
        string(name: 'CLUSTER_NAME', defaultValue: '', description: 'Provide a name to Kubernetes Cluster')

        choice(name: 'OPERATION', choices: ['create', 'delete'], description: 'Choose an operation to Kubernetes Cluster')

        choice(name: 'REGION', choices: ['us-west-1', 'us-west-2', 'none'], description: 'Choose an AWS region to deploy the Kubernetes Cluster')
    }

    stages {
        stage('Operations to Cluster') {
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    sh "./${params.OPERATION}.sh ${params.CLUSTER_NAME} ${params.REGION}"
                }
            }
        }
        stage('Initialize Helm and Install Tiller') {
            when {
                equals expected: "create", actual: "${params.OPERATION}"
            }
            environment {
                KUBECONFIG = "$PWD/.kube/config"
            }
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    sh "echo $KUBECONFIG"
                    sh "helm init --history-max 200"
                }
            }
        }
    }
}