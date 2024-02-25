pipeline {

    agent any

    environment {
        registry = "junxamlop/devops-beginners"
        registryCredential = 'dockerhub'
    }

    stages{

        stage('Build') {
          steps{
            sh 'echo "Build completed."'
          }
        }

        stage('Build App Image') {
          steps {
            script {
              dockerImage = docker.build registry + ":V$BUILD_NUMBER"
            }
          }
        }

        stage('Upload Image'){
          steps{
            script {
              docker.withRegistry('', registryCredential) {
                dockerImage.push("V$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }

        stage('Remove Unused docker image') {
          steps{
            sh "docker rmi $registry:V$BUILD_NUMBER"
          }
        }

        stage('Kubernetes Deploy') {
          agent {label 'MasterNode'}
            steps {
              sh "helm upgrade --install --force vprofile-stack helm/vprofilecharts --set appimage=${registry}:V${BUILD_NUMBER} --namespace prod"
            }
        }
    }


}
