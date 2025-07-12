# ==============================================================================
# LOCALS
# ==============================================================================

locals {
  # Merge de tags
  merged_tags = merge(var.common_tags, var.tags, {
    Name      = var.vm_name
    OSType    = var.os_type
    CreatedBy = "Terraform"
  })

  # Nomes de recursos de rede
  vnet_name   = var.create_vnet ? (var.vnet_name != null ? var.vnet_name : "${var.vm_name}-vnet") : null
  subnet_name = var.create_vnet ? (var.subnet_name != null ? var.subnet_name : "${var.vm_name}-subnet") : null

  # Subnet ID - usar criada ou fornecida
  subnet_id = var.create_vnet ? azurerm_subnet.main["default"].id : data.azurerm_subnet.main["existing"].id

  # Configuração de SO baseada no tipo e distribuição
  os_config = var.os_type == "linux" ? local.linux_os_config[var.linux_distribution] : {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.os_version != "20.04-LTS" ? var.os_version : "2022-Datacenter"
    version   = "latest"
  }

  # Configurações para diferentes distribuições Linux
  linux_os_config = {
    ubuntu = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = var.os_version
      version   = "latest"
    }
    centos = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = var.os_version != "20.04-LTS" ? var.os_version : "8_5"
      version   = "latest"
    }
    rhel = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = var.os_version != "20.04-LTS" ? var.os_version : "8-lvm"
      version   = "latest"
    }
    oracle = {
      publisher = "Oracle"
      offer     = "Oracle-Linux"
      sku       = var.os_version != "20.04-LTS" ? var.os_version : "ol85"
      version   = "latest"
    }
    suse = {
      publisher = "SUSE"
      offer     = "sles-15-sp3"
      sku       = var.os_version != "20.04-LTS" ? var.os_version : "gen2"
      version   = "latest"
    }
    debian = {
      publisher = "Debian"
      offer     = "debian-11"
      sku       = var.os_version != "20.04-LTS" ? var.os_version : "11"
      version   = "latest"
    }
    rocky = {
      publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
      offer     = "rockylinux"
      sku       = var.os_version != "20.04-LTS" ? var.os_version : "rockylinux-8"
      version   = "latest"
    }
    alma = {
      publisher = "almalinux"
      offer     = "almalinux"
      sku       = var.os_version != "20.04-LTS" ? var.os_version : "8-gen2"
      version   = "latest"
    }
  }

  # NSG rules padrão baseadas no SO
  default_nsg_rules = var.os_type == "linux" ? [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    ] : [
    {
      name                       = "RDP"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  # Combinar regras padrão com personalizadas
  all_nsg_rules = concat(local.default_nsg_rules, var.nsg_rules)

  # Nome dos recursos
  vm_name     = var.vm_name
  nic_name    = "${var.vm_name}-nic"
  nsg_name    = "${var.vm_name}-nsg"
  pip_name    = "${var.vm_name}-pip"
  osdisk_name = "${var.vm_name}-osdisk"

  # Validação de configuração
  validate_auth = var.os_type == "windows" ? var.admin_password != null : (
    var.admin_password != null || var.ssh_public_key != null
  )

  # Validação de rede
  validate_network = var.create_vnet || var.subnet_id != null
}

# ==============================================================================
# DATA SOURCES
# ==============================================================================

# Resource Group existente
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Subnet existente (apenas se não criar nova)
data "azurerm_subnet" "main" {
  for_each = var.create_vnet ? {} : { "existing" = var.subnet_id }

  name                 = split("/", each.value)[10]
  virtual_network_name = split("/", each.value)[8]
  resource_group_name  = split("/", each.value)[4]
}

# ==============================================================================
# NETWORK RESOURCES
# ==============================================================================

# Virtual Network (resource direto se não usar módulo)
resource "azurerm_virtual_network" "main" {
  for_each = var.create_vnet ? { "default" = local.vnet_name } : {}

  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = true
    precondition {
      condition     = local.validate_network
      error_message = "Você deve fornecer subnet_id ou configurar create_vnet = true."
    }
  }
}

# Subnet (resource direto se não usar módulo)
resource "azurerm_subnet" "main" {
  for_each = var.create_vnet ? { "default" = local.subnet_name } : {}

  name                 = each.value
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main["default"].name
  address_prefixes     = var.subnet_address_prefixes

  lifecycle {
    create_before_destroy = true
  }
}

# ==============================================================================
# RANDOM RESOURCES
# ==============================================================================

# Sufixo aleatório para recursos únicos
resource "random_id" "vm_id" {
  keepers = {
    vm_name = var.vm_name
  }
  byte_length = 4
}

# ==============================================================================
# NETWORK SECURITY GROUP
# ==============================================================================

resource "azurerm_network_security_group" "main" {
  name                = local.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Network Security Rules
resource "azurerm_network_security_rule" "main" {
  for_each = { for idx, rule in local.all_nsg_rules : rule.name => rule }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
}

# ==============================================================================
# PUBLIC IP
# ==============================================================================

resource "azurerm_public_ip" "main" {
  for_each = var.create_public_ip ? { "default" = local.pip_name } : {}

  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  zones               = var.zone != null ? [var.zone] : null

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = true
  }
}

# ==============================================================================
# NETWORK INTERFACE
# ==============================================================================

resource "azurerm_network_interface" "main" {
  name                           = local.nic_name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  accelerated_networking_enabled = var.enable_accelerated_networking
  ip_forwarding_enabled          = var.enable_ip_forwarding

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.main["default"].id : null
  }

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Associar NSG à Network Interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# ==============================================================================
# DATA DISKS
# ==============================================================================

resource "azurerm_managed_disk" "data" {
  for_each = { for idx, disk in var.data_disks : disk.name => disk }

  name                 = each.value.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.size_gb
  zone                 = var.zone

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = true
  }
}

# ==============================================================================
# VIRTUAL MACHINE
# ==============================================================================

resource "azurerm_linux_virtual_machine" "main" {
  for_each = var.os_type == "linux" ? { "default" = local.vm_name } : {}

  name                            = each.value
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = var.ssh_public_key != null ? var.disable_password_authentication : false
  admin_password                  = var.admin_password
  zone                            = var.zone
  availability_set_id             = var.availability_set_id
  proximity_placement_group_id    = var.proximity_placement_group_id

  # Validação de autenticação
  lifecycle {
    precondition {
      condition     = local.validate_auth
      error_message = "Para VMs Linux, você deve fornecer admin_password ou ssh_public_key."
    }

    create_before_destroy = true
  }

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    name                 = local.osdisk_name
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = local.os_config.publisher
    offer     = local.os_config.offer
    sku       = local.os_config.sku
    version   = local.os_config.version
  }

  # SSH Key (se fornecida)
  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.ssh_public_key
    }
  }

  # Boot Diagnostics
  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.boot_diagnostics_storage_account
    }
  }

  # Identity
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
    }
  }

  tags = local.merged_tags
}

resource "azurerm_windows_virtual_machine" "main" {
  for_each = var.os_type == "windows" ? { "default" = local.vm_name } : {}

  name                         = each.value
  location                     = var.location
  resource_group_name          = var.resource_group_name
  size                         = var.vm_size
  admin_username               = var.admin_username
  admin_password               = var.admin_password
  zone                         = var.zone
  availability_set_id          = var.availability_set_id
  proximity_placement_group_id = var.proximity_placement_group_id

  # Validação de autenticação
  lifecycle {
    precondition {
      condition     = local.validate_auth
      error_message = "Para VMs Windows, você deve fornecer admin_password."
    }

    create_before_destroy = true
  }

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    name                 = local.osdisk_name
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = local.os_config.publisher
    offer     = local.os_config.offer
    sku       = local.os_config.sku
    version   = local.os_config.version
  }

  # Boot Diagnostics
  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.boot_diagnostics_storage_account
    }
  }

  # Identity
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.identity_ids : null
    }
  }

  tags = local.merged_tags
}

# ==============================================================================
# ATTACH DATA DISKS
# ==============================================================================

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  for_each = { for idx, disk in var.data_disks : disk.name => disk }

  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = var.os_type == "linux" ? azurerm_linux_virtual_machine.main["default"].id : azurerm_windows_virtual_machine.main["default"].id
  lun                = each.value.lun
  caching            = each.value.caching

  depends_on = [
    azurerm_linux_virtual_machine.main,
    azurerm_windows_virtual_machine.main,
  ]
}
