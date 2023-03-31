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
        // stage("Quality Gate") {
        //     steps {
        //         timeout(time: 2, unit: 'MINUTES') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }
        stage ('docker login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage ('building & tagging docker image') {
            steps {
                sh 'docker build -t srinu7150/webapp:$BUILD_NUMBER .'
                sh 'docker tag srinu7150/webapp:$BUILD_NUMBER srinu7150/webapp:latest'
            }
        }
        stage ('pushing to docker hub') {
            steps {
                sh 'docker push srinu7150/webapp:$BUILD_NUMBER'
                sh 'docker push srinu7150/webapp:latest'
            }
        }
    }
    post{
        always {  
            sh 'docker logout'
        }
    }
}
