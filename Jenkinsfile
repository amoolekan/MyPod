pipeline {
agent any

tools {
maven 'MVN'
}

stages{

// 1. Build the war file.
stage('Build'){
steps {
sh 'mvn clean package'
}
}

// 2. testing the build.
stage('Test'){
steps {
sh 'mvn test'
}
}

  
// 3. Code Analysis
stage('Code Analysis'){
steps {
//withSonarQubeEnv(credentialsId: 'sonarqube-jenkins', installationName: 'Sonarqube') {
withSonarQubeEnv(installationName: 'Sonarqube') {
 sh "mvn sonar:sonar"
}
}
}
  
// 4. Renaming the package to test.war
//  stage('Rename Package'){
//  steps {
//  sh 'mv ${WORKSPACE}/target/*.war ${WORKSPACE}/target/test.war'
//  }
//  }

// 5. Build the docker image with doockefile and tag it.
// Jenkins acccount was added to docker group and used as default credential.
stage('Build & Tag Docker Image') { steps {
script {
withDockerRegistry(credentialsId: '') { sh "docker build -t amoolekan/mytest:latest ."
}
}
}
}

// 6. Push docker inage to dockerhub.
// amoolekan username for dockerhub was used as credentail for the credID DOCKERHUB.
stage('Push Docker Image') { steps {
script {
withDockerRegistry(credentialsId: 'DOCKERHUB') { sh "docker push amoolekan/mytest:latest"
}
}
}
}

// 7. Deploy K8
stage('K8-Deploy') {
steps {
withKubeConfig(caCertificate: '', clusterName: 'my-webapp', contextName: '', credentialsId: 'k8-token', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://4AAA76E599ABD3637EB03F1050D1EBDD.yl4.eu-north-1.eks.amazonaws.com') {
sh 'kubectl apply -f mytest.yaml'
sh 'kubectl get pods '
sh 'kubectl get svc'
}
}
}

// 8. Email Notification 
stage('Email Notification'){
steps {
sh 'echo Sending email'
}
    
post {
    
always {
emailext (
subject: '$DEFAULT_SUBJECT',
to: '$DEFAULT_RECIPIENTS',
body: '$DEFAULT_CONTENT', 
attachLog: 'true',
recipientProviders: [ requestor() ]
)
}
    
//success {
//emailext (
//subject: '$DEFAULT_SUBJECT',
//to: '$DEFAULT_RECIPIENTS',
//body: '$DEFAULT_CONTENT', 
//attachLog: 'true',
//recipientProviders: [ requestor() ]
//)
//}

//failure {
//emailext (
//subject: '$DEFAULT_SUBJECT',
//to: '$DEFAULT_RECIPIENTS',
//body: '$DEFAULT_CONTENT', 
//attachLog: 'true',
//recipientProviders: [ requestor() ]
//)
//}
    
//unstable {
//emailext (
//subject: '$DEFAULT_SUBJECT',
//to: '$DEFAULT_RECIPIENTS',
//body: '$DEFAULT_CONTENT', 
//attachLog: 'true',
//recipientProviders: [ requestor() ]
//)
//}
    
}    
}

  
// 9. Build Information
stage('Build Info'){
steps {
sh 'echo This is the build Id ${BUILD_ID}'
sh 'echo This is the build URL ${BUILD_URL}'
}
}

}
}

