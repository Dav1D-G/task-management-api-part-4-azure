variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "log_analytics_workspace_name" {
  type = string
}

variable "container_apps_environment_name" {
  type = string
}

variable "container_app_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "container_image" {
  type        = string
  description = "Container image URI deployed to Azure Container Apps"
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
