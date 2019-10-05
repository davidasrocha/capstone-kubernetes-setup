pipeline {
    agent any

    stages {
        stage('Operations to Cluster') {
            when {
                branch 'master'
            }
            steps {
                input {
                    message "What's cluster name?"
                    ok "Confirm Cluster Name"
                    parameters {
                        string(name: 'CLUSTER_NAME', defaultValue: '', description: 'Provide a name to Kubernetes Cluster')
                    }
                }
                input {
                    message "What's cluster operation?"
                    ok "Confirm Operation"
                    parameters {
                        choice(name: 'OPERATION', choices: ['create', 'delete'], description: 'Choose an operation to Kubernetes Cluster')
                    }
                }
                input {
                    message "What's cluster region?"
                    ok "Confirm Cluster Name"
                    parameters {
                        choice(name: 'REGION', choices: ['us-west-1', 'us-west-2', 'none'], description: 'Choose an AWS region to deploy the Kubernetes Cluster')
                    }
                }
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    sh "./${params.OPERATION}.sh ${params.CLUSTER_NAME} ${params.REGION}"
                }
            }
        }
    }
}