pipeline {
    agent any
    environment
    {
     AWS_ACCOUNT_ID="505874605366"             
     AWS_DEFAULT_REGION="us-east-1" 
     IMAGE_REPO_NAME="oz-sample"
     REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
     registry= "505874605366.dkr.ecr.us-east-1.amazonaws.com/oz-sample"
     //DOCKERHUB_CREDENTIALS=credentials('docker')
    }
    tools {
    maven 'maven'
    }

    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Shi191099/oz-war-s3-ecr-doker.git'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage("Pushing artifcats to S3"){
        steps{
               withAWS(credentials:'aws', endpointUrl:'https://s3.us-east-1.amazonaws.com', region:'us-east-1') {
                       sh 'echo "Uploading content with AWS creds"'
                       //sh 'aws s3 ls'
                       sh 'aws s3 cp target/*.war s3://s3-copy-one-2-one'
                  }
            }
        }
        stage('Docker Build and Tag') {
              steps{
                  script {
                      dockerImage = docker.build registry
                      sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 505874605366.dkr.ecr.us-east-1.amazonaws.com'
                      sh 'docker build -t oz-sample .'
                      sh 'docker tag oz-sample:latest 505874605366.dkr.ecr.us-east-1.amazonaws.com/oz-sample:latest'
                      sh 'docker push 505874605366.dkr.ecr.us-east-1.amazonaws.com/oz-sample:latest'
                      sh "docker run -d -p 8081:8080 --rm --name ozsh oz-sample:latest"
                      }
              }
        }
    }
}
