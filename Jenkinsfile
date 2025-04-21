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
