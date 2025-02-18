pipeline {
    agent any
    stages {
        stage ('checkout') {
            steps {
                echo "cloneing git repository"
            }
        }
        stage ('build') {
            steps {
                echo "performing maven build"
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