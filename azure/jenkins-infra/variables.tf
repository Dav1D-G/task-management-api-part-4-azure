variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_cidr" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "bastion_subnet_cidr" {
  type = list(string)
}

variable "admin_username" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "vm_size" {
  type = string
}
