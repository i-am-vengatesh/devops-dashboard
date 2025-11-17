pipeline {
    agent { 
            docker {
            image 'vengateshbabu1605/devops-ci-agent:latest'
            args '-u root:root'
            label 'blackkey'
            reuseNode true
        } 
          }

    environment {
        DOCKER_IMAGE = "vengateshbabu1605/devops-dashboard:latest"
        DOCKER_CREDENTIALS = 'dockerhub-creds'   // Docker Hub credentials ID
        GIT_CREDENTIALS = 'git-creds'            // GitHub credentials ID
    }

    stages {
        stage('Checkout DevOps Dashboard Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/i-am-vengatesh/devops-dashboard.git',
                    credentialsId: 'git-creds'
            }
        }

        stage('Verify Checkout') {
            steps {
                sh 'echo "Repo cloned successfully at $(pwd)"'
                sh 'ls -la'
            }
        }
    }

    post {
        success {
            echo 'Checkout completed successfully!'
        }
        failure {
            echo 'Checkout failed. Please check logs.'
        }
    }
}
