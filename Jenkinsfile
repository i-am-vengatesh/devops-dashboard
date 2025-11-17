pipeline {
    agent {

        label 'blackkey'
        }

environment {

    ENV http_proxy http://proxy-dmz.altera.com:912
    ENV HTTP_PROXY http://proxy-dmz.altera.com:912

}
    

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("vengateshbabu1605/devops-dashboard:latest")
                }
            }
        }
        stage('Run Unit Tests') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'pytest app/tests/'
                    }
                }
            }
        }
    }
}
