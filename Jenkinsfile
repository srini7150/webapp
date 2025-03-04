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

                    def currentVersion = readFile('pipeline/versions/version.counter').trim()
                    def versionElements = currentVersion.split("\\.")

                    if( "${BRANCH_NAME}" == "release" ) {
                        versionElements[versionElements.length - 1] = (versionElements[versionElements.length - 1] as Integer) + 1
                    }
                    VERSION = versionElements.join(".")
                    echo "incremented version is ${VERSION}"

                    if ( "${BRANCH_NAME}" == "develop" ) {
                        VERSION = "${VERSION}-SNAPSHOT"
                    }
                    else if ( "${BRANCH_NAME}" =~ /^feature/ ) {
                        def VERSION_NAME = sh(script: "echo ${BRANCH_NAME} | sed 's~^feature/~~'", returnStdout: true).trim()
                        VERSION = "${VERSION_NAME}-SNAPSHOT"
                    }
                    else {
                        VERSION = "${VERSION}"
                    }

                    echo "VERSION for ${BRANCH_NAME} is: ${VERSION}"

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

        stage ('version-increment') {
            when {
                expression {
                    "${BRANCH_NAME}" == "release"
                }
            }
            steps {
                script {
                    sh "echo ${VERSION} > pipeline/versions/version.counter"
                    sh """
                        git config --global user.name=srini7150
                        git config --global user.email=srinivasdevops7150@gmail.com

                        git add pipeline/versions/version.counter
                        git commit -m "updated version from jenkins as ${VERSION}"
                        git push https://${GIT_CREDS_USR}:${GIT_CREDS_PSW}@github.com/srini7150/webapp.git
                    """
                }
            }
        }
    }
}