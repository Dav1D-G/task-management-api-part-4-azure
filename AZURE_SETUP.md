# Azure Setup

This file records the non-secret Azure settings used by the Part 4 Azure implementation.

## Target Subscription

- Subscription ID: `47833278-569e-459a-9601-d67fa4fdb210`
- Tenant ID: `cda9a1f6-c3a2-40f6-a425-89316170fa38`
- Default region: `westeurope`

## Service Principal

- Client ID: `2b81f02e-e739-4b5f-bca4-c4b4c660fac6`
- Client secret: store outside the repository only

## Local Environment Variables

```powershell
$env:ARM_TENANT_ID       = "cda9a1f6-c3a2-40f6-a425-89316170fa38"
$env:ARM_SUBSCRIPTION_ID = "47833278-569e-459a-9601-d67fa4fdb210"
$env:ARM_CLIENT_ID       = "2b81f02e-e739-4b5f-bca4-c4b4c660fac6"
$env:ARM_CLIENT_SECRET   = "<set-locally>"
$env:AZURE_CONFIG_DIR    = "$PWD\\.azure"
```

Then log in:

```powershell
az login --service-principal --username $env:ARM_CLIENT_ID --password $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID
az account set --subscription $env:ARM_SUBSCRIPTION_ID
```

## Jenkins Credentials

Create these credentials/variables in Jenkins:

- Username/password credential `azure-sp`
  - username: Client ID
  - password: Client Secret
- Global environment variable `AZURE_TENANT_ID`
- Global environment variable `AZURE_SUBSCRIPTION_ID`

## SSH Key

Current Terraform VM config points to:

`C:/Users/Dawid/.ssh/id_rsa.pub`
