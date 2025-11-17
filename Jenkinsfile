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
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: GIT_CREDENTIALS,
                    url: 'https://github.com/i-am-vengatesh/devops-dashboard.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh '''
                pip install --upgrade pip
                pip install -r app/requirements.txt
                pytest app/tests --junitxml=reports/test-results.xml
                '''
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    docker build -t $DOCKER_IMAGE .
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Container Security Scan') {
            steps {
                sh '''
                trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_IMAGE > reports/trivy-report.txt
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                cd infra
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**', fingerprint: true
        }
    }
}
