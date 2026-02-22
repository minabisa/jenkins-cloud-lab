pipeline {
  agent { label 'tf' }

  environment {
    TF_IN_AUTOMATION = 'true'
    AWS_CREDS = credentials('aws-creds')
    AWS_DEFAULT_REGION    = 'us-east-1'
  }

  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Init') {
      steps { dir('terraform-demo') { sh 'terraform init -input=false' } }
    }

    stage('Validate') {
      steps { dir('terraform-demo') { sh 'terraform validate' } }
    }

    stage('Plan') {
      steps {
        dir('terraform-demo') {
          sh '''
            terraform plan -out=tfplan -input=false \
              -var="bucket_name=mina-jenkins-demo-12345"
          '''
        }
      }
    }

    stage('Apply (manual)') {
      when { branch 'main' }
      steps {
        input message: 'Apply Terraform now?', ok: 'Apply'
        dir('terraform-demo') { sh 'terraform apply -input=false tfplan' }
      }
    }
  }
}