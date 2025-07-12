terraform {
  required_version = ">= 1.0"
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

# Módulo VM Windows com disco adicional
module "windows_vm" {
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
  os_type    = "windows"
  os_version = "2022-Datacenter"

  # Credenciais
  admin_username = var.admin_username
  admin_password = var.admin_password

  # Configurações de disco
  os_disk_size_gb = var.os_disk_size_gb
  data_disks = [
    {
      name                 = "${var.vm_name}-datadisk-01"
      size_gb              = var.data_disk_size_gb
      storage_account_type = "Premium_LRS"
      caching              = "ReadWrite"
      lun                  = 0
    }
  ]

  # Configurações avançadas
  enable_boot_diagnostics = true
  identity_type           = "SystemAssigned"

  # NSG Rules personalizadas
  nsg_rules = [
    {
      name                       = "AllowHTTP"
      priority                   = 1100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowHTTPS"
      priority                   = 1101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  # Tags
  tags = var.tags
}
