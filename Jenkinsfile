pipeline {
    agent {

        label 'blackkey'
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
                    dockerImage = docker.build("vengateshbabu1605/devops-dashboard:latest",
                "--no-cache .")
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
