pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'your-docker-registry'
        DOCKER_IMAGE_NAME = 'your-docker-image-name'
        GITHUB_REPO = 'your-github-repo'
        GITHUB_BRANCH = 'your-github-branch'
        AWS_REGION = 'your-aws-region'
        ECS_CLUSTER = 'your-ecs-cluster'
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
                    def credentials = 'aws-creds'
                    def awsAccountId = awsUtils.getAccountId(credentials)
                    def ecrRepoUrl = "https://${awsAccountId}.dkr.ecr.${AWS_REGION}.amazonaws.com/${DOCKER_HUB_REPO}:${BUILD_NUMBER}"
                    
                    ecsUtils.withEcs(credentials, AWS_REGION) {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${awsAccountId}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                        sh "docker pull ${ecrRepoUrl}"
                        sh "docker tag ${ecrRepoUrl} ${DOCKER_IMAGE_NAME}"
                        sh "docker push ${DOCKER_IMAGE_NAME}"
                        sh "aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --force-new-deployment"
                    }
                }
            }
        }	
