pipeline {
agent any

tools {
maven 'MVN'
}

stages{

// 2. Build the war file.
stage('Build'){
steps {
sh 'mvn clean package'
}
}

// 1. Compiling and testing the code.
stage('Test'){
steps {
sh 'mvn test'
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
stage('K8-Deploy') {
steps {
withKubeConfig(caCertificate: '', clusterName: 'my-webapp', contextName: '', credentialsId: 'k8-token', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://4AAA76E599ABD3637EB03F1050D1EBDD.yl4.eu-north-1.eks.amazonaws.com') {
sh 'kubectl apply -f deployment-service.yml'
sh 'kubectl get pods '
sh 'kubectl get svc'
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


