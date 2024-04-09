pipeline {
    agent any
    
    tools {
        maven 'MVN'
    }
    
stages{

     // 1. Compiling and testing the code.
       // stage('Compile & Test'){
          //  steps {
           //     sh 'mvn clean compile test'
           //     }
            //    }
    
     // 2. Build the workload and add it to archive (optional).
        stage('Build'){
            steps {
                sh 'mvn clean package'
                }
                    post {
                        success {
                            echo 'Archiving the artifacts ${BUILD_ID}'
                            archiveArtifacts artifacts: '**/target/*.war'
                    }
                    }
                    }  
    
    // 4. Renaming the package to Test.war
      //  stage('Rename Package'){
        //    steps {
           //     sh 'mv ${WORKSPACE}/target/*.war ${WORKSPACE}/target/test.war'
           //       }
           //         }

    
    // 5. Build the docker image with doockefile and tag it.
    // Jenkins acccount was added to docker group and used used as default credential.
        stage('Build & Tag Docker Image') { steps {
            script {
            withDockerRegistry(credentialsId: '') { sh "docker build -t amoolekan/mytest:latest ."
                    }
                    }
                    }
                    }    

    // 6. image pushed to dockerhub.
    // amoolekan username for dockerhub was used as credentail for the credID DOCKERHUB.
        stage('Push Image') { steps {
        script {
            withDockerRegistry(credentialsId: 'DOCKERHUB') { sh "docker push amoolekan/mytest:latest"
                    }
                    }
                    }
                    }    

    // 7. Copy yaml file to minikube cluster server
    stage('Copy YAML'){
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'SSH_MINIKUBE', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/*.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }  
     
}

       // 8. Connect to minikube and run kubectl command
node {
  def remote = [:]
  remote.name = 'minikube'
  remote.host = '172.31.46.174'
  remote.user = 'olalekan'
  remote.password = 'Solution@123'
  remote.allowAnyHosts = true
  stage('Remote SSH') {
    sshCommand remote: remote, command: "kubectl apply -f /home/olalekan/kubeworkspace/mydockerprj.yaml"
  }
}

    // 9. Copy yaml file to minikube cluster server
        stage('Build Info'){
            steps {
                sh 'echo This is the build Id ${BUILD_ID}'
                sh 'echo This is the build URL ${BUILD_URL}'
           }
      }


    
}
 
