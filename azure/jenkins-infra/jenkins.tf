resource "azurerm_linux_virtual_machine" "jenkins" {
  name                = "vm-jenkins"
  resource_group_name = azurerm_resource_group.jenkins.name
  location            = azurerm_resource_group.jenkins.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.jenkins.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    set -e

    PLATFORM_DIR="/opt/jenkins-platform"

    apt-get update
    apt-get install -y docker.io curl git
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ${var.admin_username}
    mkdir -p "$PLATFORM_DIR/agents/ci"
    mkdir -p "$PLATFORM_DIR/agents/docker"
    mkdir -p "$PLATFORM_DIR/agents/infra"

    cat > "$PLATFORM_DIR/docker-compose.yml" <<'YAML'
    services:
      jenkins:
        image: jenkins/jenkins:lts
        container_name: jenkins-part4-azure
        restart: unless-stopped
        ports:
          - "8080:8080"
          - "50000:50000"
        volumes:
          - jenkins_home:/var/jenkins_home

      agent_ci:
        build: ./agents/ci
        image: jenkins-agent:ci
        container_name: jenkins-agent-ci
        restart: unless-stopped
        environment:
          - JENKINS_URL=$${JENKINS_URL:-http://jenkins:8080}
          - JENKINS_AGENT_NAME=$${CI_AGENT_NAME:-agent-ci}
          - JENKINS_SECRET=$${CI_AGENT_SECRET}
          - JENKINS_AGENT_WORKDIR=/home/jenkins/agent
        depends_on:
          - jenkins

      agent_docker:
        build: ./agents/docker
        image: jenkins-agent:docker
        container_name: jenkins-agent-docker
        restart: unless-stopped
        user: root
        environment:
          - JENKINS_URL=$${JENKINS_URL:-http://jenkins:8080}
          - JENKINS_AGENT_NAME=$${DOCKER_AGENT_NAME:-agent-docker}
          - JENKINS_SECRET=$${DOCKER_AGENT_SECRET}
          - JENKINS_AGENT_WORKDIR=/home/jenkins/agent
          - AZURE_TENANT_ID=$${AZURE_TENANT_ID}
          - AZURE_SUBSCRIPTION_ID=$${AZURE_SUBSCRIPTION_ID}
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
        depends_on:
          - jenkins

      agent_infra:
        build: ./agents/infra
        image: jenkins-agent:infra
        container_name: jenkins-agent-infra
        restart: unless-stopped
        environment:
          - JENKINS_URL=$${JENKINS_URL:-http://jenkins:8080}
          - JENKINS_AGENT_NAME=$${INFRA_AGENT_NAME:-agent-infra}
          - JENKINS_SECRET=$${INFRA_AGENT_SECRET}
          - JENKINS_AGENT_WORKDIR=/home/jenkins/agent
          - AZURE_TENANT_ID=$${AZURE_TENANT_ID}
          - AZURE_SUBSCRIPTION_ID=$${AZURE_SUBSCRIPTION_ID}
        depends_on:
          - jenkins

    volumes:
      jenkins_home:
    YAML

    cat > "$PLATFORM_DIR/.env" <<'ENV'
    JENKINS_URL=http://jenkins:8080

    CI_AGENT_NAME=agent-ci
    CI_AGENT_SECRET=REPLACE_CI_AGENT_SECRET

    DOCKER_AGENT_NAME=agent-docker
    DOCKER_AGENT_SECRET=REPLACE_DOCKER_AGENT_SECRET

    INFRA_AGENT_NAME=agent-infra
    INFRA_AGENT_SECRET=REPLACE_INFRA_AGENT_SECRET

    AZURE_TENANT_ID=cda9a1f6-c3a2-40f6-a425-89316170fa38
    AZURE_SUBSCRIPTION_ID=47833278-569e-459a-9601-d67fa4fdb210
    ENV

    cat > "$PLATFORM_DIR/agents/ci/Dockerfile" <<'DOCKERFILE'
    FROM jenkins/inbound-agent:latest

    USER root
    RUN apt-get update \
      && apt-get install -y --no-install-recommends git nodejs npm ca-certificates curl \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*
    USER jenkins
    DOCKERFILE

    cat > "$PLATFORM_DIR/agents/docker/Dockerfile" <<'DOCKERFILE'
    FROM jenkins/inbound-agent:latest

    USER root
    ARG DOCKER_VERSION=26.1.4
    RUN apt-get update \
      && apt-get install -y --no-install-recommends git nodejs npm ca-certificates curl unzip \
      && curl -fsSL "https://download.docker.com/linux/static/stable/x86_64/docker-$${DOCKER_VERSION}.tgz" \
        | tar -xz -C /usr/local/bin --strip-components=1 docker/docker \
      && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*
    USER jenkins
    DOCKERFILE

    cat > "$PLATFORM_DIR/agents/infra/Dockerfile" <<'DOCKERFILE'
    FROM jenkins/inbound-agent:latest

    USER root
    ARG TERRAFORM_VERSION=1.8.4
    RUN apt-get update \
      && apt-get install -y --no-install-recommends git curl unzip ca-certificates \
      && curl -fsSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/$${TERRAFORM_VERSION}/terraform_$${TERRAFORM_VERSION}_linux_amd64.zip" \
      && unzip /tmp/terraform.zip -d /usr/local/bin \
      && rm -f /tmp/terraform.zip \
      && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*
    USER jenkins
    DOCKERFILE

    docker pull jenkins/jenkins:lts
    docker volume create jenkins_home || true
    docker rm -f jenkins-part4-azure >/dev/null 2>&1 || true
    docker run -d \
      --name jenkins-part4-azure \
      --restart unless-stopped \
      -p 8080:8080 \
      -p 50000:50000 \
      -v jenkins_home:/var/jenkins_home \
      jenkins/jenkins:lts
  EOF
  )
}
