FROM jenkins/inbound-agent:latest

USER root
ARG TERRAFORM_VERSION=1.8.4
RUN apt-get update \
  && apt-get install -y --no-install-recommends git curl unzip ca-certificates \
  && curl -fsSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && unzip /tmp/terraform.zip -d /usr/local/bin \
  && rm -f /tmp/terraform.zip \
  && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER jenkins
