pipeline {
    agent any

    environment {
        MVN = "mvn11='docker run -it --rm --name my-maven-project -v maven-repo:/root/.m2 -v "$(pwd)":/usr/src/mymaven -w /usr/src/mymaven maven:3.9.9-sapmachine-11 mvn"
    }
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