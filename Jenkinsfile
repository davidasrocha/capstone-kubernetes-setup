pipeline {
    agent any

    parameters {
        choice(name: 'REGION', choices: ['us-west-1', 'us-west-2'], description: 'Choose an AWS region to deploy the Kubernetes Cluster')
    }

    stages {
        stage('Setup Cluster') {
            when {
                branch 'master'
            }
            steps {
                withAWS(region: "${params.REGION}", credentials: 'AWS_DEVOPS') {
                    // TODO: insert input option
                    sh "./create.sh capstone ${params.REGION}"
                }
            }
        }
    }
}