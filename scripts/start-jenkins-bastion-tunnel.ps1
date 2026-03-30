param(
    [ValidateSet("ssh", "jenkins")]
    [string]$Mode = "ssh",

    [int]$LocalPort
)

$ErrorActionPreference = "Stop"

$SubscriptionId = "47833278-569e-459a-9601-d67fa4fdb210"
$ResourceGroup = "rg-jenkins-part4-platform"
$BastionName = "bas-jenkins"
$VmResourceId = "/subscriptions/47833278-569e-459a-9601-d67fa4fdb210/resourceGroups/rg-jenkins-part4-platform/providers/Microsoft.Compute/virtualMachines/vm-jenkins"
$AzureConfigDir = "C:\Users\Dawid\Desktop\Jenkins\.azure"
$SshKeyPath = "C:\Users\Dawid\.ssh\jenkins_azure_ed25519"

if (-not $LocalPort) {
    $LocalPort = if ($Mode -eq "ssh") { 22025 } else { 18080 }
}

$ResourcePort = if ($Mode -eq "ssh") { 22 } else { 8080 }

$env:AZURE_CONFIG_DIR = $AzureConfigDir

Write-Host "Mode: $Mode"
Write-Host "Local port: $LocalPort"
Write-Host "Remote port: $ResourcePort"
Write-Host "Bastion: $BastionName"
Write-Host "VM: $VmResourceId"
Write-Host ""

if ($Mode -eq "ssh") {
    Write-Host "After the tunnel is ready, connect using:"
    Write-Host "ssh -i $SshKeyPath -p $LocalPort azureuser@127.0.0.1"
    Write-Host ""
}
else {
    Write-Host "After the tunnel is ready, open:"
    Write-Host "http://127.0.0.1:$LocalPort"
    Write-Host ""
}

az account set --subscription $SubscriptionId
az network bastion tunnel `
    --name $BastionName `
    --resource-group $ResourceGroup `
    --target-resource-id $VmResourceId `
    --resource-port $ResourcePort `
    --port $LocalPort
