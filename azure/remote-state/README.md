# Terraform Remote State (Azure)

This stack creates the shared storage resources used by Terraform remote state.

## What is created

- Resource group
- Storage account
- Blob container for Terraform state

## Usage

Apply this stack first, then copy the resulting values into:
- `azure/jenkins-infra/backend.hcl`
- `azure/app-infra/backend.hcl`
