pipeline {
    agent any
    tools {
        maven '3.9.1'
    }
    environment {     
        DOCKERHUB_CREDENTIALS = credentials('docker-hub')
    }
    stages {
        stage ('environment test') {
            steps {
                sh 'docker version'
                sh 'mvn --version'
                sh 'java --version'
            }
        }
        stage ("build & SonarQube analysis") {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }
        stage ('docker login') {
            steps {
                sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
            }
        }
        stage ('building docker image') {
            steps {
                sh 'echo building docker image....'
            }
        }
        stage ('tagging docker image') {
            steps {
                sh 'echo tagging docker image....'
            }
        }
        stage ('push') {
            steps {
                sh 'echo pushing docker image to docker hub...'
            }
        }
    }
    post{
        always {  
            sh 'docker logout'
        }
    }
}
