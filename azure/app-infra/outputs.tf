output "acr_login_server" {
  value = azurerm_container_registry.app.login_server
}

output "acr_name" {
  value = azurerm_container_registry.app.name
}

output "app_url" {
  value = "https://${azurerm_container_app.app.latest_revision_fqdn}"
}
