output "resource_group_name" {
  value = azurerm_resource_group.jenkins.name
}

output "jenkins_vm_name" {
  value = azurerm_linux_virtual_machine.jenkins.name
}

output "jenkins_private_ip" {
  value = azurerm_network_interface.jenkins.private_ip_address
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion.ip_address
}

output "bastion_name" {
  value = azurerm_bastion_host.jenkins.name
}

output "jenkins_principal_id" {
  value = azurerm_linux_virtual_machine.jenkins.identity[0].principal_id
}
