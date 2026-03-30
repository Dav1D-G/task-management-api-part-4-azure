resource "azurerm_resource_group" "jenkins" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "jenkins" {
  name                = "vnet-jenkins"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
  address_space       = var.vnet_cidr
}

resource "azurerm_subnet" "public" {
  name                 = "subnet-jenkins-public"
  resource_group_name  = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  address_prefixes     = var.public_subnet_cidr
}

resource "azurerm_subnet" "private" {
  name                 = "subnet-jenkins-private"
  resource_group_name  = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  address_prefixes     = var.private_subnet_cidr
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  address_prefixes     = var.bastion_subnet_cidr
}
