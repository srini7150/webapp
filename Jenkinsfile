pipeline {
    agent {
        label 'laptop'
    }
    
    environment {
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
        PATH = "$PATH:$JAVA_HOME/bin"
        MVN_SETTINGS = "pipeline/settings.xml"
        SONAR_TOKEN = credentials('sonar-token')
    }

    options {
        ansiColor('xterm')
    }

    stages {
        stage ('build') {
            steps {
                sh"mvn -s ${MVN_SETTINGS} clean compile"
            }
        }
        stage ('sonar-scan') {
            steps {
                sh"""
                    mvn -s ${MVN_SETTINGS} sonar:sonar \
                    -Dsonar.projectKey=webapp \
                    -Dsonar.host.url=http://192.168.1.6:9000 \
                    -Dsonar.settings=sonar-project.properites \
                    -Dsonar.login=${SONAR_TOKEN}
                
                """
            }
        }
        stage ('publish') {
            steps {
                echo "publish to jfrog"
            }
        }
    }
}