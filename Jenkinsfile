pipeline {
  agent any

  environment {
    GIT_CREDENTIALS_ID = 'github-creds'
    BACKEND_IMAGE = "backend-app"
    FRONTEND_IMAGE = "frontend-app"
  }

  stages {
    stage('Checkout') {
      steps {
        git credentialsId: "${GIT_CREDENTIALS_ID}", url: 'git@github.com:mohamedtahani/devops-lab.git'
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

    stage('List Images') {
      steps {
        sh 'docker images'
      }
    }
  }
}
