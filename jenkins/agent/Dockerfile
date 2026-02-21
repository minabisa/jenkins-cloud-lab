FROM jenkins/ssh-agent:jdk17

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG TF_VERSION=1.7.5
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm -f /tmp/terraform.zip \
    && terraform -version

WORKDIR /home/jenkins
USER jenkinscd