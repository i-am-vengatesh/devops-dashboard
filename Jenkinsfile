pipeline {
    agent {
        label 'blackkey' // Your Jenkins agent label
    }

    environment {
        DOCKER_IMAGE = "vengateshbabu1605/devops-dashboard:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "docker.io" // Change if using a different registry
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
                    // Build the Docker image with a unique tag per build
                    dockerImage = docker.build(DOCKER_IMAGE, "--no-cache .")
                }
            }
        }

        stage('Lint') {
            steps {
                script {
                    // Run flake8 inside the Docker container
                    dockerImage.inside {
                        sh 'flake8 app/ --count --show-source --statistics'
                    }
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    // Run pytest inside the Docker container
                    dockerImage.inside {
                        sh 'pytest app/tests/'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image to the Docker registry (needs credentials configured in Jenkins)
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "dockerhub-creds") {
                        dockerImage.push()
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after build
        }
        success {
            echo "Build, lint, test, and push stages succeeded!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
