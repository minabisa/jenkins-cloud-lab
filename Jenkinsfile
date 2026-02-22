pipeline {
  agent { label 'tf' }

  environment {
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID     = credentials('aws-creds')
    AWS_DEFAULT_REGION    = 'us-east-1'
  }

  options { timestamps() }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
      post {
        success {
          slackSend color: '#36a64f',
                    message: "✅ *Checkout SUCCESS*\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}\nBranch: ${env.BRANCH_NAME}\n<${env.BUILD_URL}|Open Build>"
        }
        failure {
          slackSend color: '#ff0000',
                    message: "❌ *Checkout FAILED*\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Open Build>"
        }
      }
    }

    stage('Init') {
      steps {
        dir('terraform-demo') {
          sh 'terraform init -input=false'
        }
      }
      post {
        success {
          slackSend color: '#36a64f',
                    message: "✅ *Terraform Init SUCCESS* — Build #${env.BUILD_NUMBER}"
        }
        failure {
          slackSend color: '#ff0000',
                    message: "❌ *Terraform Init FAILED* — Build #${env.BUILD_NUMBER}"
        }
      }
    }

    stage('Validate') {
      steps {
        dir('terraform-demo') {
          sh 'terraform validate'
        }
      }
      post {
        success {
          slackSend color: '#36a64f',
                    message: "✅ *Terraform Validate SUCCESS* — Build #${env.BUILD_NUMBER}"
        }
        failure {
          slackSend color: '#ff0000',
                    message: "❌ *Terraform Validate FAILED* — Build #${env.BUILD_NUMBER}"
        }
      }
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
      post {
        success {
          slackSend color: '#36a64f',
                    message: "✅ *Terraform Plan SUCCESS* — Build #${env.BUILD_NUMBER}"
        }
        failure {
          slackSend color: '#ff0000',
                    message: "❌ *Terraform Plan FAILED* — Build #${env.BUILD_NUMBER}"
        }
      }
    }

    stage('Apply (manual)') {
  steps {
    echo "About to request approval..."
    input message: 'Apply Terraform now?', ok: 'Proceed (Apply)'
    dir('terraform-demo') {
      sh 'terraform apply -input=false tfplan'
    }
  }

        
      
      post {
        success {
          slackSend color: '#36a64f',
                    message: "🚀 *Terraform Apply SUCCESS*\nBuild #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Open Build>"
        }
        failure {
          slackSend color: '#ff0000',
                    message: "❌ *Terraform Apply FAILED* — Build #${env.BUILD_NUMBER}"
        }
      }
    }
  

  post {
    success {
      slackSend color: '#36a64f',
                message: "🎉 *PIPELINE SUCCESS*\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Open Build>"
    }
    failure {
      slackSend color: '#ff0000',
                message: "🔥 *PIPELINE FAILED*\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Open Build>"
    }
    unstable {
      slackSend color: '#ffcc00',
                message: "⚠️ *PIPELINE UNSTABLE*\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
    }
  }
}
