pipeline {
    agent any
    environment {     
        SONAR_TOKEN = credentials('sonar-token')
        MVN_SETTINGS = 'pipeline/settings.xml'
    }
    stages {
        stage ('environment test') {
            steps {
                sh 'mvn --version'
                sh 'java --version'
            }
        }
        stage ('build') {
            steps {
                sh "mvn -s ${MVN_SETTINGS} clean compile"
            }
        }
        stage ('test') {
            steps {
                sh "mvn -s ${MVN_SETTINGS} test -Dmaven.install.skip=true -Dmaven.deploy.skip=true"
            }
        }
        stage ("build & SonarQube analysis") {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                        mvn -s ${MVN_SETTINGS} sonar:sonar
                        -Dsonar.projectKey=webapp \
                        -Dsonar.host.url=http://192.168.1.6:9000 \
                        -Dsonar.settings=sonar-project.properites \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage ('publish') {
            steps {
                sh """
                    mvn -s ${MVN_SETTINGS} deploy -Dmaven.test.skip=true -Dsonar.skip=true -Dinstall.skip=true
                """
            }
        }

    }
    post{
        always {  
            sh 'Pipeline is finished'
        }
    }
}
