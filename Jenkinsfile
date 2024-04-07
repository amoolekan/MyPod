pipeline {
    agent any
    
    tools {
        maven 'MVN'
    }
    
stages{

    stage('Compile & Test'){
            steps {
                sh 'mvn clean compile test'
                sh 'echo Test completed'
                }
                        }
    
        stage('Build'){
            steps {
                sh 'mvn clean package'
                sh 'echo Clean build completed'
                  }
            post {
                success {
                    echo 'Archiving the artifacts 3'
                    archiveArtifacts artifacts: '**/target/*.war'
                    
                        }
                }
                   }



stage('Build & Tag Docker Image') { steps {
script {
withDockerRegistry(credentialsId: '') { sh "docker build -t amoolekan/mydockerprj:latest ."
}
}
}
}    

stage('Push Image') { steps {
script {
withDockerRegistry(credentialsId: 'DOCKERHUB') { sh "docker push amoolekan/mydockerprj:latest"
}
}
}
}    
  


stage('Deploy To Kubernetes') { steps {
withKubeConfig(credentialsId: 'K8S', serverUrl: 'https://13.60.17.60')  {
sh "kubectl apply -f mydockerprj.yaml"
}
}
}

    
    
    stage('Rename Package'){
            steps {
                sh 'mv ${WORKSPACE}/target/*.war ${WORKSPACE}/target/mylab.war'
                  }
                        }
    
     stage('Validation'){
            steps {
                input 'Kindly Approve This Package'
                  }
                        }
    
    stage('Deployment'){
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'SSH_SERVER', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '/target/', sourceFiles: '**/*.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }  
     stage('Build Info'){
            steps {
                sh 'echo This is the build Id ${BUILD_ID}'
                sh 'echo This is the build URL ${BUILD_URL}'
           }
        }
}
}
