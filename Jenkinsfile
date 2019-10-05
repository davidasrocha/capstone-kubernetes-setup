pipeline {
    agent any

    stages {
        stage('Setup Cluster') {
            when {
                branch 'master'
            }
            steps {
                withAWS(region: 'us-west-2', credentials: 'AWS_DEVOPS') {
                    // TODO: insert input option
                    sh './create.sh capstone us-west-2'
                }
            }
        }
    }
}