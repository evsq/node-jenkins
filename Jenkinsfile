pipeline {
    environment {
      REPOSITORY_URI = "evsq/node-test"
      HELM_APP_NAME = "node-test"
      HELM_CHART_DIRECTORY = "node-test"
    }
    agent {
        kubernetes {
            defaultContainer 'jnlp'
            yamlFile 'build.yaml'
        }
    }

      stages {
        stage('Test') {
          steps {
            container('docker'){
                sh 'ls -l'
              }
          }  
        }

        stage('Build Image') {
          steps {
            container('docker'){
              withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker login --username="${USERNAME}" --password="${PASSWORD}"'
                sh "docker build -t ${REPOSITORY_URI}:${BUILD_NUMBER} ."
              }  
            }
          }  
        } 

        stage('Testing') {
          steps {
            container('docker') { 
              sh "docker run ${REPOSITORY_URI}:${BUILD_NUMBER} npm run test "                 
            }
          }
        }

        stage('Push Image') {
          steps {
            container('docker'){
              withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh "docker push ${REPOSITORY_URI}:${BUILD_NUMBER}"
              }                 
            }
          }
        }

        stage('Deploy Image'){
          steps {          
            container('helm'){
                sh "helm lint ./${HELM_CHART_DIRECTORY}"
                sh "helm upgrade --install --set image.tag=${BUILD_NUMBER} ${HELM_APP_NAME} ./helm/${HELM_CHART_DIRECTORY}"
            }
          }  
        } 
      }     
}