pipeline {
    agent any
    tools {
        maven '3.9.1'
    }
    environment {     
        DOCKERHUB_CREDENTIALS = credentials('docker-hub')
        SONARQUBE_URL = 'https://localhost:9000'
        SONAR_PROJECT_NAME = 'webapp'
        SONAR_PROJECT_KEY = 'webapp'
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
                    sh "mvn clean package sonar:sonar \
                    -Dsonar.host.url=${SONARQUBE_URL} \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.projectName=${SONAR_PROJECT_NAME}"
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
