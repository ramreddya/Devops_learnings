pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'https://hub.docker.com/'
        DOCKER_IMAGE_NAME = 'spl'
        AWS_REGION = 'us-east-1'
        ECS_CLUSTER = 'sample'
        ECS_SERVICE = 'your-ecs-service'
        ECS_TASK_DEFINITION = 'your-ecs-task-definition'
    }

    stages {
        stage('Build') {
            steps {
                sh "docker build -t ${env.DOCKER_IMAGE_NAME} ."
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u ${env.DOCKER_USERNAME} -p ${env.DOCKER_PASSWORD} ${env.DOCKER_REGISTRY}"
                    sh "docker tag ${env.DOCKER_IMAGE_NAME} ${env.DOCKER_REGISTRY}/${env.DOCKER_IMAGE_NAME}"
                    sh "docker push ${env.DOCKER_REGISTRY}/${env.DOCKER_IMAGE_NAME}"
                }
            }
        }

	stage('Deploy to ECS') {
            steps {
                script {
                    withAWS(credentials: 'aws-creds', region: AWS_REGION) {
                        ecsUpdateService(
                            cluster: ECS_CLUSTER,
                            service: ECS_SERVICE,
                            taskDefinition: ECS_TASK_DEFINITION,
                            image: "${DOCKER_REGISTRY}/my-image:${IMAGE_TAG}"
                        )
                    }
                }
            }
        }
    }
}
