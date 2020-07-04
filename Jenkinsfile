podTemplate(label: 'mypod', serviceAccount: 'jenkins-agent', containers: [ 
    containerTemplate(
      name: 'docker', 
      image: 'docker', 
      command: 'cat', 
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'kubectl', 
      image: 'amaceog/kubectl',
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi', 
      ttyEnabled: true, 
      command: 'cat'
    ),
    containerTemplate(
      name: 'helm', 
      image: 'alpine/helm:2.14.0', 
      resourceRequestCpu: '100m',
      resourceLimitCpu: '300m',
      resourceRequestMemory: '300Mi',
      resourceLimitMemory: '500Mi',
      ttyEnabled: true, 
      command: 'cat'
    )
  ],

  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    hostPathVolume(mountPath: '/usr/local/bin/helm', hostPath: '/usr/local/bin/helm')
  ]
  ) {
    node('mypod') {

        def REPOSITORY_URI = "evsq/node-test"
        def HELM_APP_NAME = "node-test"
        def HELM_CHART_DIRECTORY = "node-test"

        stage('Build Image'){
            container('docker'){
              withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh 'docker login --username="${USERNAME}" --password="${PASSWORD}"'
                sh "docker build -t ${REPOSITORY_URI}:${BUILD_NUMBER} ."
              }  
            }
        } 

        stage('Testing') {
            container('docker') { 
              sh "docker run ${REPOSITORY_URI}:${BUILD_NUMBER} npm run test "                 
            }
        }

        stage('Push Image'){
            container('docker'){
              withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh "docker push ${REPOSITORY_URI}:${BUILD_NUMBER}"
              }                 
            }
        }

        stage('Deploy Image'){
            container('helm'){
                sh "helm lint ./${HELM_CHART_DIRECTORY}"
                sh "helm upgrade --install --set image.tag=${BUILD_NUMBER} ${HELM_APP_NAME} ./${HELM_CHART_DIRECTORY}"
            }
        }      
    }
}