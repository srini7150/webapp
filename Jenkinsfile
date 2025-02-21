pipeline {

    agent {
        label 'laptop'
    }

parameters {
  booleanParam (name: 'SonarScan', defaultValue: true, description: 'To run sonar scan in pipeline')
}

    options {
        ansiColor('xterm')
    }
    
    environment {
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
        PATH = "$PATH:$JAVA_HOME/bin"
        MVN_SETTINGS = "pipeline/settings.xml"
        SONAR_TOKEN = credentials('sonar-token')
        GIT_CREDS = credentials('github-credentials')
        VERSION = ""
    }

    stages {

        stage ('versioning') {
            steps {
                script {

                    VERSION = readFile('pipeline/versions/version.counter').trim()

                    if ( "${BRANCH_NAME}" == "release" ) {
                        VERSION = "${VERSION}-${BUILD_NUMBER}"
                    } 
                    else if ( "${BRANCH_NAME}" == "develop" ) {
                        VERSION = "${VERSION}-SNAPSHOT"
                    }
                    else {
                        VERSION = "1.0.0-SNAPSHOT"
                    }
                    sh "mvn -s ${MVN_SETTINGS} versions:set -DnewVersion=${VERSION}"
                }
            }
        }

        stage ('build') {
            steps {
                sh"mvn -s ${MVN_SETTINGS} clean compile"
            }
        }

        stage ('tests') {
            steps {
                sh "mvn -s ${MVN_SETTINGS} test"
            }
        }

        stage ('sonar-scan') {
            when {
                expression {
                    params.SonarScan == true
                }
            }
            steps {
                withSonarQubeEnv('sonarqube') {
                sh "mvn -s ${MVN_SETTINGS} sonar:sonar \
                    -Dsonar.projectKey=webapp \
                    -Dsonar.host.url=http://192.168.1.6:9000 \
                    -Dsonar.login=${SONAR_TOKEN}"
                }
            }
        }

        stage ('tag') {
            when {
                expression {
                    "${BRANCH_NAME}" == "release"
                }
            }
            steps {
                sh """
                    git tag ${VERSION}
                    git push https://${GIT_CREDS_USR}:${GIT_CREDS_PSW}@github.com/srini7150/webapp.git tag ${VERSION}
                """
            }
        }

        stage ('publish') {
            steps {
                sh"mvn -s ${MVN_SETTINGS} deploy -DskipTests=true -Dmaven.install.skip=true"
            }
        }
    }
}