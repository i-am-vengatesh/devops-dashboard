pipeline {
    agent {
        label 'blackkey' // Your Jenkins agent label
    }

    environment {
        DOCKER_IMAGE = "vengateshbabu1605/devops-dashboard:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "docker.io" // Change if using a different registry
        DOCKER_CREDS = credentials('dockerhub-token')
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

        
       

       
        stage('Docker Login and Push') {
            steps {
                sh '''
                    docker logout || true
                    echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                    docker tag vengateshbabu1605/devops-dashboard:49 docker.io/vengateshbabu1605/devops-dashboard:${env.BUILD_NUMBER}
                    docker push docker.io/vengateshbabu1605/devops-dashboard:49
                '''
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
