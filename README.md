# Task Management API - Part 4 (Azure + Jenkins)

This directory contains the Azure variant of the Part 4 assignment:
- Jenkins platform provisioned separately from application infrastructure
- Terraform remote state in Azure Storage
- Application infrastructure on Azure Container Apps
- Jenkins pipeline for build, test, image push, Terraform plan/apply, and deployment validation

## Repository Structure

- `jenkins-app/` - Node.js sample app, tests, Dockerfile, and Azure-oriented Jenkins pipeline
- `jenkins-platform/` - Docker Compose and Dockerfiles for Jenkins controller and agents
- `azure/remote-state/` - Terraform stack for the shared backend storage account
- `azure/jenkins-infra/` - Terraform stack for Jenkins platform infrastructure
- `azure/app-infra/` - Terraform stack for application runtime infrastructure

## Target Azure Mapping

- `S3 + DynamoDB` -> `Storage Account + Blob Container`
- `ECR` -> `Azure Container Registry`
- `ECS Fargate + ALB` -> `Azure Container Apps + ingress`
- `CloudWatch Logs` -> `Log Analytics`
- `Secrets Manager` -> `Key Vault`
- `EC2 + IAM role` -> `Azure VM + Managed Identity`

## Expected Flow

1. Provision remote Terraform state manually.
2. Provision Jenkins platform infrastructure manually.
3. Start Jenkins and configure agents/credentials.
4. Run the pipeline from `jenkins-app/Jenkinsfile`.
5. Deploy `dev` automatically.
6. Require manual approval for `prod`.

## Azure Authentication

Do not store Azure secrets in Terraform files or in the repository.

Use environment variables for local Terraform and Azure CLI sessions:

```powershell
$env:ARM_TENANT_ID       = "<tenant-id>"
$env:ARM_SUBSCRIPTION_ID = "<subscription-id>"
$env:ARM_CLIENT_ID       = "<client-id>"
$env:ARM_CLIENT_SECRET   = "<client-secret>"
```

Recommended Azure CLI setup for local work:

```powershell
$env:AZURE_CONFIG_DIR = "$PWD\\.azure"
az login --service-principal `
  --username $env:ARM_CLIENT_ID `
  --password $env:ARM_CLIENT_SECRET `
  --tenant $env:ARM_TENANT_ID
az account set --subscription $env:ARM_SUBSCRIPTION_ID
```

For Jenkins, store the service principal in credentials and expose:
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `azure-sp` as username/password credentials

## Current State

This Azure variant is being built from the completed AWS implementation and aligned with the Part 3 Azure architecture. The structure and core files are in place so Terraform modules and the pipeline can now be completed iteratively.
