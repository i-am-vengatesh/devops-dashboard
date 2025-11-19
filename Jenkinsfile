pipeline {
    agent {
        label 'blackkey'
    }

    environment {
        DOCKER_IMAGE = "vengateshbabu1605/devops-dashboard:${env.BUILD_NUMBER}"
        DOCKER_CREDS = credentials('dockerhub-token')
        GIT_CRED_ID = 'git-creds'
        GIT_REPO_URL = 'https://github.com/i-am-vengatesh/devops-dashboard.git'
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

        stage('Docker Login and Push') {
            steps {
                sh '''
                    docker logout || true
                    echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                    docker push $DOCKER_IMAGE
                '''
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                sh "sed -i 's|image: .*|image: $DOCKER_IMAGE|g' k8s/deployment.yaml"
            }
        }

        stage('Commit and Push Manifest to Git') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.GIT_CRED_ID, usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        git config user.name "jenkins"
                        git config user.email "jenkins@yourdomain.com"
                        git add k8s/deployment.yaml
                        git commit -m "Update image to ${BUILD_NUMBER} [ci skip]" || echo "No changes to commit"
                        git push https://$GIT_USER:$GIT_PASS@github.com/i-am-vengatesh/devops-dashboard.git HEAD:main
                    '''
                }
            }
        }
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
