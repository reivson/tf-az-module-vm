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
    Purpose     = "linux-distributions-test"
  }
}

# Criar Virtual Network e Subnet
resource "azurerm_virtual_network" "example" {
  name                = "${var.base_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    Environment = "example"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "${var.base_name}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# VM Ubuntu 22.04 LTS
module "ubuntu_vm" {
  count  = var.create_ubuntu ? 1 : 0
  source = "../../"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_name             = "${var.base_name}-ubuntu"
  vm_size             = var.vm_size

  subnet_id        = azurerm_subnet.example.id
  create_public_ip = var.create_public_ip

  os_type            = "linux"
  linux_distribution = "ubuntu"
  os_version         = "22.04-LTS"

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  admin_password = var.admin_password

  tags = merge(var.tags, {
    Distribution = "Ubuntu"
    Version      = "22.04-LTS"
  })
}

# VM CentOS 8
module "centos_vm" {
  count  = var.create_centos ? 1 : 0
  source = "../../"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_name             = "${var.base_name}-centos"
  vm_size             = var.vm_size

  subnet_id        = azurerm_subnet.example.id
  create_public_ip = var.create_public_ip

  os_type            = "linux"
  linux_distribution = "centos"
  os_version         = "8_5"

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  admin_password = var.admin_password

  tags = merge(var.tags, {
    Distribution = "CentOS"
    Version      = "8.5"
  })
}

# VM Red Hat Enterprise Linux 8
module "rhel_vm" {
  count  = var.create_rhel ? 1 : 0
  source = "../../"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_name             = "${var.base_name}-rhel"
  vm_size             = var.vm_size

  subnet_id        = azurerm_subnet.example.id
  create_public_ip = var.create_public_ip

  os_type            = "linux"
  linux_distribution = "rhel"
  os_version         = "8-lvm"

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  admin_password = var.admin_password

  tags = merge(var.tags, {
    Distribution = "RHEL"
    Version      = "8"
  })
}

# VM Oracle Linux 8.5
module "oracle_vm" {
  count  = var.create_oracle ? 1 : 0
  source = "../../"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_name             = "${var.base_name}-oracle"
  vm_size             = var.vm_size

  subnet_id        = azurerm_subnet.example.id
  create_public_ip = var.create_public_ip

  os_type            = "linux"
  linux_distribution = "oracle"
  os_version         = "ol85"

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  admin_password = var.admin_password

  tags = merge(var.tags, {
    Distribution = "Oracle Linux"
    Version      = "8.5"
  })
}

# VM SUSE Linux Enterprise Server 15 SP3
module "suse_vm" {
  count  = var.create_suse ? 1 : 0
  source = "../../"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_name             = "${var.base_name}-suse"
  vm_size             = var.vm_size

  subnet_id        = azurerm_subnet.example.id
  create_public_ip = var.create_public_ip

  os_type            = "linux"
  linux_distribution = "suse"
  os_version         = "gen2"

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  admin_password = var.admin_password

  tags = merge(var.tags, {
    Distribution = "SLES"
    Version      = "15-SP3"
  })
}

# VM Rocky Linux 8
module "rocky_vm" {
  count  = var.create_rocky ? 1 : 0
  source = "../../"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vm_name             = "${var.base_name}-rocky"
  vm_size             = var.vm_size

  subnet_id        = azurerm_subnet.example.id
  create_public_ip = var.create_public_ip

  os_type            = "linux"
  linux_distribution = "rocky"
  os_version         = "rockylinux-8"

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  admin_password = var.admin_password

  tags = merge(var.tags, {
    Distribution = "Rocky Linux"
    Version      = "8"
  })
}
