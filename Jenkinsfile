pipeline {

    agent {
        label 'laptop'
    }

    options {
        ansiColor('xterm')
    }
    
    environment {
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
        PATH = "$PATH:$JAVA_HOME/bin"
        MVN_SETTINGS = "pipeline/settings.xml"
    }

    stages {
        stage ('build') {
            steps {
                sh"mvn -s ${MVN_SETTINGS} clean compile"
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