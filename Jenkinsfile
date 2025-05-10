pipeline {
    agent any
    environment {
        TF_VAR_region = "ap-south-1"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/JaiSinghShah/aws-business-onboarding-destroy-ec2.git'
            }
        }

        stage('Terraform Init/Destroy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS-Cred']]) {
                    bat 'terraform init'
                    bat 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
