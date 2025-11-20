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
                        // Generate both coverage and JUnit XML report
                        sh 'pytest --cov=app --cov-report=xml:reports/tests/coverage.xml --junitxml=reports/tests/results.xml app/tests/'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            agent {
                docker {
                    image 'vengateshbabu1605/sonar-scanner-node:latest'
                    label 'blackkey'
                    reuseNode true
                }
            }
            environment {
                SONAR_TOKEN = credentials('sonar-token1')
            }
            steps {
                sh '''
                    sonar-scanner \
                        -Dsonar.projectKey=devops_dashboard \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://10.244.192.41:9000 \
                        -Dsonar.token=$SONAR_TOKEN \
                        -Dsonar.python.coverage.reportPaths=reports/tests/coverage.xml
                '''
            }
        }

        stage('Archive Test Results') {
            steps {
                // Archive the JUnit XML and coverage report for Jenkins
                junit 'reports/tests/results.xml'
                archiveArtifacts artifacts: 'reports/tests/coverage.xml', allowEmptyArchive: true
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

        // ...rest of your pipeline if any...
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
