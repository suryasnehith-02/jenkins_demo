// Define a variable for the Docker image name
def DOCKER_IMAGE_REPO = "local/flask-app"

pipeline {
    // Run the pipeline on any available agent (Jenkins node)
    agent any

    // Configuration for automatic build trigger upon Git push
    triggers {
        // This is necessary to enable the GitHub webhook trigger setup in Jenkins UI
        githubPush() 
    }

    // Define environment variables, using Jenkins' built-in variables
    environment {
        // Tag the image with the unique Jenkins build number
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // SCM is typically checked out automatically by the Jenkins SCM configuration
                echo "Source code checked out successfully."
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building image: ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}"
                    // Build and tag with both the specific build number and 'latest'
                    sh "docker build -t ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG} -t ${DOCKER_IMAGE_REPO}:latest ."
                }
            }
        }
    }
    
    // Post-build actions for cleanup
    post {
        always {
            // Clean up the local workspace directory
            cleanWs()
            
            // Clean up the local image (optional, but good practice if you don't need it locally)
            script {
                try {
                    echo "Cleaning up local Docker images..."
                    sh "docker rmi ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}"
                    sh "docker rmi ${DOCKER_IMAGE_REPO}:latest"
                } catch (err) {
                    echo "Image removal failed (might be in use or already removed): ${err}"
                }
            }
        }
    }
}