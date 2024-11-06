pipeline {
    agent any
    environment {
        REGISTRY = 'docker.io'
        REPO = 'viswaraje/nodejs-web-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: env.GIT_BRANCH, url: 'https://github.com/Viswaraje/nodejs-web-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH.split('/')[1]
                    def envType = branchName == 'main' ? 'production' : 'staging'
                    docker.build("${REPO}:${branchName}", "--build-arg NODE_ENV=${envType} .")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-viswaraje') {
                        def branchName = env.GIT_BRANCH.split('/')[1]
                        docker.image("${REPO}:${branchName}").push()
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH.split('/')[1]
                    def port = branchName == 'main' ? 80 : 8081
                    sh "docker stop ${branchName} || true && docker rm ${branchName} || true"
                    sh "docker run -d -p ${port}:3000 --name ${branchName} ${REPO}:${branchName}"
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
