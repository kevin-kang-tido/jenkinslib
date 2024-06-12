def call(Map config = [:]) {
    // Default values
    def image = config.get('image', 'my-default-image')
    def registry = config.get('registry', 'my-default-registry')
    def tag = config.get('tag', 'latest')
    def containerPort = config.get('containerPort', '8080')
    def hostPort = config.get('hostPort', '8080')

    pipeline {
        agent any

        stages {
            stage('Git Clone') {
                steps {
                    git branch: 'main', url: 'https://github.com/SattyaPiseth/nextjs-framework.git'
                }
            }

            stage('Build Docker Image') {
                steps {
                    script {
                    echo "Building Docker image: ${registry}/${image}:${tag}"
                    
                        sh """
                            docker build -t ${registry}/${image}:${tag} .
                            docker rm -f ${image}
                        """
                    }
                }
            }

            stage('Docker hub login'){
                steps{
                    script{
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                            sh """
                                docker login -u ${USER} -p ${PASS}
                                docker push ${registry}/${image}:${tag}
                            """
                        }
                    }
                }
            }

            stage('Deploy Docker Container') {
                steps {
                    script {
                        echo "Deploying Docker container: ${registry}/${image}:${tag}"
                        sh """
                            docker run -d -p ${hostPort}:${containerPort} --name ${image} ${registry}/${image}:${tag}
                        """
                    }
                }
            }
        }
    }
}
