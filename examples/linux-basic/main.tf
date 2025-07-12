terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Criar Resource Group para o exemplo
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "example"
    Purpose     = "terraform-module-test"
  }
}

# Criar Virtual Network e Subnet
resource "azurerm_virtual_network" "example" {
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    Environment = "example"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Módulo VM Linux
module "linux_vm" {
  source = "../../"

  # Configurações básicas
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_name             = var.vm_name
  vm_size             = var.vm_size

  # Configurações de rede
  subnet_id        = azurerm_subnet.example.id
  create_public_ip = var.create_public_ip

  # Configurações do SO
  os_type    = "linux"
  os_version = "20.04-LTS"

  # Credenciais
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  admin_password = var.admin_password

  # Tags
  tags = var.tags
}
