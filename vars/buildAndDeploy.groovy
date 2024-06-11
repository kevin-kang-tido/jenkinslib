def call(Map config = [:]) {
    try {
        // Set default values with Groovy's elvis operator
        def image = config.get('image') ?: 'my-default-image'
        def registry = config.get('registry') ?: 'my-default-registry'
        def tag = config.get('tag') ?: 'latest'
        def containerPort = config.get('containerPort') ?: '8080'
        def hostPort = config.get('hostPort') ?: '8080'

        pipeline {
            agent any

            stages {
                stage('Prepare Dockerfile') {
                    steps {
                        script {
                            // Load the Dockerfile content from the library resource
                            def dockerfileContent = libraryResource 'angular.dockerfile'
                            
                            // Ensure this step is wrapped in a node block
                            node {
                                writeFile file: 'Dockerfile', text: dockerfileContent
                            }
                        }
                    }
                }

                stage('Git Clone') {
                    steps {
                        script {
                            // Add your Git clone steps here
                            echo 'Cloning Git repository...'
                             git branch: 'main', url: 'https://github.com/SattyaPiseth/angular-muyleang-ing.git'
                        }
                    }
                }

                stage('Build Docker Image') {
                    steps {
                        script {
                            echo 'Building Docker image...'
                            sh """
                                docker build -t ${registry}/${image}:${tag} .
                            """
                        }
                    }
                }

                stage('Run Docker Container') {
                    steps {
                        script {
                            echo 'Running Docker container...'
                            sh """
                                docker run -d -p ${hostPort}:${containerPort} ${registry}/${image}:${tag}
                            """
                        }
                    }
                }

                // Add more stages as required
            }

            post {
                always {
                    echo 'Pipeline finished.'
                }
                success {
                    echo 'Pipeline succeeded.'
                }
                failure {
                    echo 'Pipeline failed.'
                }
            }
        }
    } catch (Exception e) {
        error "Pipeline execution failed: ${e.message}"
    }
}
