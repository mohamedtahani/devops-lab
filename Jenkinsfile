pipeline {
  agent any

  tools {
    nodejs "node18"
  }

  environment {
    GIT_CREDENTIALS_ID = 'github-creds'
    scannerHome = tool 'sonarscanner'
    AWS_REGION = 'us-east-1'
    AWS_ACCOUNT_ID = '890742564895'

    ECR_BACKEND_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/backend-app"
    ECR_FRONTEND_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/frontend-app"
    ECR_MONGO_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/mongodb"
  }

  stages {

    stage('Run Tests') {
      steps {
        dir('backend') {
          sh 'npm ci'
          sh 'npm run prebuildtest'
        }
      }
    }

    stage('SonarQube Scan') {
      steps {
        withSonarQubeEnv('sonarserver') {
          sh "${scannerHome}/bin/sonar-scanner"
        }
      }
    }

    stage("Quality Gate") {
      steps {
        timeout(time: 1, unit: 'HOURS') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    stage('Build with Docker Compose') {
      steps {
        sh 'docker compose build'
      }
    }

    stage('Set Version Tag') {
      steps {
        script {
          env.VERSION = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        }
      }
    }

    stage('Login to ECR') {
      steps {
        sh '''
          aws ecr get-login-password --region $AWS_REGION | \
          docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
        '''
      }
    }

    stage('Push to ECR') {
      steps {
        sh '''
          # Tag and push backend
          docker tag backend-app $ECR_BACKEND_REPO:$VERSION
          docker tag backend-app $ECR_BACKEND_REPO:latest
          docker push $ECR_BACKEND_REPO:$VERSION
          docker push $ECR_BACKEND_REPO:latest

          # Tag and push frontend
          docker tag frontend-app $ECR_FRONTEND_REPO:$VERSION
          docker tag frontend-app $ECR_FRONTEND_REPO:latest
          docker push $ECR_FRONTEND_REPO:$VERSION
          docker push $ECR_FRONTEND_REPO:latest

          # Pull and push MongoDB if needed
          docker pull mongo:6.0
          docker tag mongo:6.0 $ECR_MONGO_REPO:6.0
          docker push $ECR_MONGO_REPO:6.0
        '''
      }
    }

    stage('Docker Cleanup') {
      steps {
        sh '''
          docker rmi backend-app frontend-app mongo:6.0 || true
          docker rmi $ECR_BACKEND_REPO:$VERSION $ECR_FRONTEND_REPO:$VERSION $ECR_MONGO_REPO:6.0 || true
          docker rmi $ECR_BACKEND_REPO:latest $ECR_FRONTEND_REPO:latest || true
          docker system prune -af || true
        '''
      }
    }

    stage('List Images') {
      steps {
        sh 'docker images'
      }
    }

    stage('Cleanup Workspace') {
      steps {
        cleanWs()
      }
    }
  }
}
