pipeline {
    agent any
    environment {
        REGISTRY = 'docker.io'
        REPO = 'viswaraje/nodejs-web-app'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH ?: 'main' // Ensure branch is set
                    git branch: branchName, url: 'https://github.com/Viswaraje/nodejs-web-app.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH.replace('refs/heads/', '')
                    def envType = branchName == 'main' ? 'production' : 'staging'
                    docker.build("${REPO}:${branchName}", "--build-arg NODE_ENV=${envType} .")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-viswaraje') {
                        def branchName = env.GIT_BRANCH.replace('refs/heads/', '')
                        docker.image("${REPO}:${branchName}").push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH.replace('refs/heads/', '')
                    def port = branchName == 'main' ? 80 : 8081
                    if (isUnix()) {
                        sh """
                            docker stop ${branchName} || exit 0
                            docker rm ${branchName} || exit 0
                            docker run -d -p ${port}:3000 --name ${branchName} ${REPO}:${branchName}
                        """
                    } else {
                        bat """
                            docker stop ${branchName} || exit 0
                            docker rm ${branchName} || exit 0
                            docker run -d -p ${port}:3000 --name ${branchName} ${REPO}:${branchName}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
