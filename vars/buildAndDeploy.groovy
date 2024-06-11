groovyCopy code
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
            stage('Build Docker Image') {
                steps {
                    script {
                        echo "Building Docker image: ${registry}/${image}:${tag}"
                        sh """
                            docker build -t ${registry}/${image}:${tag} .
                            docker push ${registry}/${image}:${tag}
                        """
                    }
                }
            }

            stage('Deploy Docker Container') {
                steps {
                    script {
                        echo "Deploying Docker container: ${registry}/${image}:${tag}"
                        sh """
                            docker run -d -p ${hostPort}:${containerPort} ${registry}/${image}:${tag}
                        """
                    }
                }
            }
        }
    }
}
