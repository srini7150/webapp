pipeline {
    agent any
    stages {
        stage ('build') {
            steps {
                sh"${MVN} clean compile"
            }
        }
        stage ('sonar-scan') {
            steps {
                echo "performing sonar scan"
            }
        }
        stage ('publish') {
            steps {
                echo "publish to jfrog"
            }
        }
    }
}