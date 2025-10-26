// Define variables outside the pipeline block for easy management
def DOCKER_IMAGE_REPO = "local/flask-app"

pipeline {
    // Run the pipeline on any available agent (Jenkins node)
    agent any

    triggers {
        // This enables the GitHub webhook trigger setup in Jenkins UI
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
                echo "Source code checked out successfully."
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building image: ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}"
                    // Using 'bat' for Windows execution
                    bat "docker build -t ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG} -t ${DOCKER_IMAGE_REPO}:latest ."
                }
            }
        }
    }
    
    // The 'post' section is modified to skip deleting the Docker image tags.
    post {
        always {
            // Clean up the local workspace directory
            cleanWs()
            
            /*
            // The image cleanup commands are commented out here 
            // so you can run the built image locally for testing.
            
            script {
                try {
                    echo "Cleaning up local Docker images..."
                    bat "docker rmi ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}"
                    bat "docker rmi ${DOCKER_IMAGE_REPO}:latest"
                } catch (err) {
                    echo "Image removal failed (might not be installed or already removed): ${err}"
                }
            }
            */
        }
    }
}
