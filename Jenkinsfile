// Define variables outside the pipeline block for easy management
def DOCKER_IMAGE_REPO = "local/flask-app"
// NOTE: We do not need REGISTRY_CREDENTIAL_ID or DOCKER_PASSWORD since we are skipping the push stage.

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
                // SCM is automatically checked out by job configuration
                echo "Source code checked out successfully."
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building image: ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}"
                    // *** CRITICAL FIX: Changed 'sh' to 'bat' for Windows execution ***
                    bat "docker build -t ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG} -t ${DOCKER_IMAGE_REPO}:latest ."
                }
            }
        }
    }
    
    // Post-build actions for cleanup
    post {
        always {
            // Clean up the local workspace directory
            cleanWs()
            
            // Attempt to remove the built image locally after a successful push
            script {
                try {
                    echo "Cleaning up local Docker images..."
                    // *** CRITICAL FIX: Changed 'sh' to 'bat' for Windows execution ***
                    bat "docker rmi ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}"
                    bat "docker rmi ${DOCKER_IMAGE_REPO}:latest"
                } catch (err) {
                    echo "Image removal failed (might not be installed or already removed): ${err}"
                }
            }
        }
    }
}
