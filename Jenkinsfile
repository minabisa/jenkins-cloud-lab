pipeline {
  agent { label 'tf' }

  environment {
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    AWS_DEFAULT_REGION    = 'us-east-1'
  }

  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
      post { success { slackSend "✅ Checkout OK: ${env.JOB_NAME} #${env.BUILD_NUMBER}" } }
    }

    stage('Init') {
      steps { dir('terraform-demo') { sh 'terraform init -input=false' } }
      post { success { slackSend "✅ Init OK: ${env.JOB_NAME} #${env.BUILD_NUMBER}" } }
    }

    stage('Validate') {
      steps { dir('terraform-demo') { sh 'terraform validate' } }
      post { success { slackSend "✅ Validate OK: ${env.JOB_NAME} #${env.BUILD_NUMBER}" } }
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
      post { success { slackSend "✅ Plan OK: ${env.JOB_NAME} #${env.BUILD_NUMBER}" } }
    }

    stage('Apply (manual)') {
      when { branch 'main' }
      steps {
        input message: 'Apply Terraform now?', ok: 'Apply'
        dir('terraform-demo') { sh 'terraform apply -input=false tfplan' }
      }
      post { success { slackSend "🚀 Apply DONE: ${env.JOB_NAME} #${env.BUILD_NUMBER}" } }
    }
  }
}