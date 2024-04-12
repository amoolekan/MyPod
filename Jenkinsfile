pipeline {
agent any

tools {
maven 'MVN'
}

stages{

// 1. Compiling and testing the code.
// stage('Compile & Test'){
// steps {
// sh 'mvn clean compile test'
// }
// }

// 2. Build the war file.
stage('Build Package'){
steps {
sh 'mvn package'
}
}

// 4. Renaming the package to test.war
//  stage('Rename Package'){
//  steps {
//  sh 'mv ${WORKSPACE}/target/*.war ${WORKSPACE}/target/test.war'
//  }
//  }

// 5. Build the docker image with doockefile and tag it.
// Jenkins acccount was added to docker group and used used as default credential.
stage('Build & Tag Docker Image') { steps {
script {
withDockerRegistry(credentialsId: '') { sh "docker build -t amoolekan/mytest:latest ."
}
}
}
}

// 6. pushed docker inage to dockerhub.
// amoolekan username for dockerhub was used as credentail for the credID DOCKERHUB.
stage('Push Docker Image') { steps {
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

// 8. remote to minikube server
//Delete existing K8s deployment and service
//apply newly pushed docker image on K8s
stage('Deploy To Kubernetes') {
steps {
script {
def remote = [:]
remote.name = 'minikube'
remote.host = '172.31.46.174'
remote.user = 'olalekan'
remote.password = 'Solution@123'
remote.allowAnyHosts = true
//sshCommand remote: remote, command: "kubectl delete svc mytest-service"
sshCommand remote: remote, command: "kubectl delete deployment mytest-deployment"
sshCommand remote: remote, command: "kubectl apply -f /home/olalekan/kubeworkspace/mytest.yaml"
}
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
}

//


