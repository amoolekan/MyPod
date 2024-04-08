pipeline {
    agent any
    
    tools {
        maven 'MVN'
    }
    
stages{

    // 1. Compiling anf testing the code.
    stage('Compile & Test'){
            steps {
                sh 'mvn clean compile test'
                sh 'echo Test completed'
                }
                }
    
    // 2. Build the workload and add it to archive (optional).
//    stage('Build'){
  //      steps {
  //          sh 'mvn clean package'
  //          sh 'echo Clean build completed'
  //          }
  //              post {
  //              success {
  //                  echo 'Archiving the artifacts 3'
  //                  archiveArtifacts artifacts: '**/target/*.war'
                                    
 //                   }
 //                   }
 //                   }                        


    // 4. Build the docker image with doockefile and tag it.
    // Jenkins acccount was added to docker group and used used as default credential.
    stage('Build & Tag Docker Image') { steps {
            script {
            withDockerRegistry(credentialsId: '') { sh "docker build -t amoolekan/mydockerprj:latest ."
                    }
                    }
                    }
                    }    

    // 5. image pushed to dockerhub.
    // amoolekan username for dockerhub was used as credentail for the credID DOCKERHUB.
    stage('Push Image') { steps {
        script {
            withDockerRegistry(credentialsId: 'DOCKERHUB') { sh "docker push amoolekan/mydockerprj:latest"
                    }
                    }
                    }
                    }    

    
    stage('Deployment'){
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'SSH_MINIKUBE', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '/target/', sourceFiles: '**/*.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }  



//    stage('Rename Package'){
  //          steps {
   //             sh 'mv ${WORKSPACE}/target/*.war ${WORKSPACE}/target/mylab.war'
   //               }
   //                     }
    
  //   stage('Validation'){
   //         steps {
   //             input 'Kindly Approve This Package'
   //               }
    //                    }
    
  //  stage('Deployment'){
 //           steps {
 //               sshPublisher(publishers: [sshPublisherDesc(configName: 'SSH_SERVER', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '/target/', sourceFiles: '**/*.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
 //           }
  //      }  
 
//stage('Build Info'){
//            steps {
//                sh 'echo This is the build Id ${BUILD_ID}'
 //               sh 'echo This is the build URL ${BUILD_URL}'
 //          }
 //     }
      
}
}
