pipeline {
  agent any

  tools {
    nodejs "node18"
  }

  environment {
    GIT_CREDENTIALS_ID = 'github-creds'
    BACKEND_IMAGE = "backend-app"
    FRONTEND_IMAGE = "frontend-app"
    scannerHome = tool 'sonarscanner'
    AWS_REGION = 'us-east-1'
    AWS_ACCOUNT_ID = '890742564895'
    ECR_BACKEND_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/backend-app"
    ECR_FRONTEND_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/frontend-app"
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

    stage('Build Backend') {
      steps {
        dir('backend') {
          sh 'docker build -t $BACKEND_IMAGE .'
        }
      }
    }

    stage('Build Frontend') {
      steps {
        dir('frontend') {
          sh 'docker build -t $FRONTEND_IMAGE .'
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
          docker tag $BACKEND_IMAGE $ECR_BACKEND_REPO:latest
          docker tag $FRONTEND_IMAGE $ECR_FRONTEND_REPO:latest

          docker push $ECR_BACKEND_REPO:latest
          docker push $ECR_FRONTEND_REPO:latest
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
