pipeline {
    agent {
        label 'blackkey'
    }

    environment {
        DOCKER_IMAGE = "vengateshbabu1605/devops-dashboard:${env.BUILD_NUMBER}"
        DOCKER_CREDS = credentials('dockerhub-token')
        GIT_CRED_ID = 'git-creds'
        GIT_REPO_URL = 'https://github.com/i-am-vengatesh/devops-dashboard.git'
        SONAR_AUTH_TOKEN = credentials('sonar-token1')
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
                    dockerImage = docker.build(DOCKER_IMAGE, "--no-cache .")
                }
            }
        }

        stage('Lint') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'flake8 app/ --count --show-source --statistics'
                    }
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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQubeServer') {
                    sh """
                        sonar-scanner \
                          -Dsonar.projectKey=devops-dashboard \
                          -Dsonar.sources=app \
                          -Dsonar.host.url=$SONAR_HOST_URL \
                          -Dsonar.login=$SONAR_AUTH_TOKEN
                    """
                }
            }
        }

        stage('Docker Login and Push') {
            steps {
                sh '''
                    docker logout || true
                    echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                    docker push $DOCKER_IMAGE
                '''
            }
        }

        // ...rest of your pipeline...
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Build, lint, test, push, and manifest update succeeded!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
