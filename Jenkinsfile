pipeline {
  agent any

  environment {
    SONARQUBE_ENV = 'SonarQubeServer'   
    DEP_CHECK_PATH = '/opt/dependency-check/bin/dependency-check.sh' 
    DOCKERHUB_REPO = "nitesh003"  
    VERSION = "${BUILD_NUMBER}"
    GIT_CREDENTIALS = credentials('git-credentials')
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
        withSonarQubeEnv('SonarQube') {
          sh "sonar-scanner"
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

  stage('Build and Push Images') {
            parallel {
                stage('Frontend') {
                    steps {
                        dir('craftista-code/frontend') {
                            buildAndPushDockerImage('craftista-frontend')
                        }
                    }
                }
                
                stage('Catalogue') {
                    steps {
                        dir('craftista-code/catalogue') {
                            buildAndPushDockerImage('craftista-catalogue')
                        }
                    }
                }
                
                stage('Recommendation') {
                    steps {
                        dir('craftista-code/recommendation') {
                            buildAndPushDockerImage('craftista-recommendation')
                        }
                    }
                }
                
                stage('Voting') {
                    steps {
                        dir('craftista-code/voting') {
                            buildAndPushDockerImage('craftista-voting')
                        }
                    }
                }
            }
        }
        
        stage('Update K8s Manifests') {
            steps {
                script {
                    sh 'git config user.email "jenkins@example.com"'
                    sh 'git config user.name "Jenkins CI"'
                    
                    sh '''
                        # Update Kustomize manifests
                        find craftista-k8s -name "*.yaml" -type f -exec sed -i "s|image: hema995/craftista-frontend:.*|image: hema995/craftista-frontend:${VERSION}|g" {} \\;
                        find craftista-k8s -name "*.yaml" -type f -exec sed -i "s|image: hema995/craftista-catalogue:.*|image: hema995/craftista-catalogue:${VERSION}|g" {} \\;
                        find craftista-k8s -name "*.yaml" -type f -exec sed -i "s|image: hema995/craftista-recommendation:.*|image: hema995/craftista-recommendation:${VERSION}|g" {} \\;
                        find craftista-k8s -name "*.yaml" -type f -exec sed -i "s|image: hema995/craftista-voting:.*|image: hema995/craftista-voting:${VERSION}|g" {} \\;
                        
                        # Update Helm values
                        sed -i "s|imageTag: .*|imageTag: ${VERSION}|g" helm-charts/craftista/values.yaml
                        sed -i "s|imageTag: .*|imageTag: ${VERSION}|g" helm-charts/craftista/values-dev.yaml
                        sed -i "s|imageTag: .*|imageTag: ${VERSION}|g" helm-charts/craftista/values-staging.yaml
                        
                        git add craftista-k8s/ helm-charts/
                        git commit -m "Update K8s manifests to version ${VERSION} [ci skip]" || echo "No changes to commit"
                        git push https://${GIT_CREDENTIALS_USR}:${GIT_CREDENTIALS_PSW}@github.com/HEMAAAAA/craftista_automation.git HEAD:main || echo "Nothing to push"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
        success {
            echo 'All Docker images built and pushed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}

def buildAndPushDockerImage(String serviceName) {
    script {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
            sh 'echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin'
            
            sh """
                docker build -t ${env.DOCKERHUB_REPO}/${serviceName}:${env.VERSION} .
                docker tag ${env.DOCKERHUB_REPO}/${serviceName}:${env.VERSION} ${env.DOCKERHUB_REPO}/${serviceName}:latest
                docker push ${env.DOCKERHUB_REPO}/${serviceName}:${env.VERSION}
                docker push ${env.DOCKERHUB_REPO}/${serviceName}:latest
            """
        }
        
        echo "Successfully pushed ${env.DOCKERHUB_REPO}/${serviceName}:${env.VERSION} to DockerHub"
    }
}