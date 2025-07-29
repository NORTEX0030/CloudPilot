pipeline {
  agent any

  environment {
    SONARQUBE_ENV = 'SonarQubeServer'     // Defined in Jenkins Configure System
    DEP_CHECK_PATH = '/opt/dependency-check/bin/dependency-check.sh' // Adjust path if different
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Trivy: Filesystem Scan') {
      steps {
        echo "Running Trivy filesystem scan..."
        sh 'trivy fs --exit-code 0 --severity MEDIUM,HIGH,CRITICAL .'
      }
    }

    stage('Trivy: Docker Image Scan') {
      steps {
        script {
          def services = ['catalogue', 'frontend', 'voting', 'recommendation']
          for (service in services) {
            echo "Building and scanning image for: ${service}"
            sh """
              docker build -t ${service}:latest ${service}
              trivy image --exit-code 0 --severity HIGH,CRITICAL ${service}:latest
            """
          }
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv("${SONARQUBE_ENV}") {
          sh """
            sonar-scanner \
              -Dsonar.projectKey=CloudPilot \
              -Dsonar.sources=. \
              -Dsonar.host.url=http://localhost:9000 \
              -Dsonar.language=multi \
              -Dsonar.sourceEncoding=UTF-8
          """
        }
      }
    }

    stage('OWASP Dependency-Check') {
      steps {
        echo "Running OWASP Dependency-Check on Java and Node.js projects..."
        sh """
          ${DEP_CHECK_PATH} --project "voting-service" --scan ./voting --format "HTML" --out ./voting/dependency-report
          ${DEP_CHECK_PATH} --project "frontend" --scan ./frontend --format "HTML" --out ./frontend/dependency-report
        """
      }
    }

    stage('Archive Reports') {
      steps {
        archiveArtifacts artifacts: '**/dependency-report/*.html', allowEmptyArchive: true
      }
    }
  }

  post {
    always {
      echo "Pipeline complete. Clean workspace if needed."
    }
  }
}

