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

        stage('CODE ANALYSIS with SONARQUBE') {

            environment {
                scannerHome = tool 'sonar4.7'
            }

            steps {
                withSonarQubeEnv('sonar') {
                      sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=demo-jenkins \
                -Dsonar.sources=src/ \
                -Dsonar.host.url=http://sn01 \
                -Dsonar.login=277f8a555a04e7173b83ff2992a723fadad3805d'''
                  }
                }

                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
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
