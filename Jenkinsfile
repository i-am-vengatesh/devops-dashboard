pipeline {
    agent {
        label 'blackkey'
    }

    environment {
        // Set proxy if needed
        // http_proxy  = 'http://your-proxy:port'
        // https_proxy = 'http://your-proxy:port'
        DOCKER_IMAGE = "vengateshbabu1605/devops-dashboard:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "docker.io" // Change to your registry
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Lint') {
            steps {
                // If you want linting; adjust as needed
                sh 'pip install flake8'
                sh 'flake8 app/ --count --show-source --statistics'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build(DOCKER_IMAGE, "--no-cache .")
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    dockerImage.inside {
                        // If you want JUnit XML output for reporting:
                        sh 'pytest app/tests/ --junitxml=app/tests/results.xml'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "docker-credentials-id") {
                        dockerImage.push()
                    }
                }
            }
        }
    }

    post {
        always {
            // Publish test results if you output JUnit XML
            junit 'app/tests/results.xml'
            cleanWs()
        }
        success {
            echo "Build, test, and push stages succeeded!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
